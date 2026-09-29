# Contribute to Keycloak Devpro Helm chart

## How to update the chart

```bash
# adds helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# searches for the latest version
helm search repo -l keycloak

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy from the sources

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# checks the Kubernetes objects generated from the chart
helm template keycloak . -f values.yaml \
--namespace keycloak > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install keycloak . -f values.yaml --create-namespace \
--set keycloak.auth.adminPassword=Admin1234 \
--set keycloak.ingress.hostname=keycloak.${NGINX_PUBLIC_IP}.sslip.io \
--set keycloak.ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
--set keycloak.global.storageClass=default \
--set keycloak.extraStartupArgs="-Dkeycloak.frontendUrl=keycloak.${NGINX_PUBLIC_IP}.sslip.io --proxy edge"
--namespace keycloak

# waits for the application to be running
kubectl wait pods -n keycloak -l app.kubernetes.io/instance=keycloak --for condition=Ready

# checks everything is ok
kubectl get svc,deploy,pod,ingress,pv,certificate -n keycloak

# manual: open https://keycloak.${NGINX_PUBLIC_IP}.sslip.io/ (and login with user/Admin1234)

# if needed, deletes the chart
helm uninstall keycloak -n keycloak
kubectl delete ns keycloak
```
