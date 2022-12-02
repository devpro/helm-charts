# Keycloack

This Helm chart will install [Keycloack](https://www.keycloak.org/) ([docs](https://www.keycloak.org/documentation), [code](https://github.com/keycloak/keycloak))
and is based from the [Bitnami Helm chart](https://bitnami.com/stack/keycloak/helm) ([docs]((https://github.com/bitnami/charts/tree/main/bitnami/keycloak))).

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

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# checks the Kubernetes objects generated from the chart
helm template keycloak . -f values.yaml \
  --namespace authentication > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install keycloak . -f values.yaml --create-namespace \
  --set keycloak.ingress.hostname=keycloak.${NGINX_PUBLIC_IP}.sslip.io \
  --set keycloak.extraEnvVars[1].value="https://keycloak.${NGINX_PUBLIC_IP}.sslip.io/auth/" \
  --namespace authentication

# checks everything is ok
kubectl get svc,deploy,pod,ingress,pv,certificate -n authentication

# manual: open https://keycloak.${NGINX_PUBLIC_IP}.sslip.io/ (and login with user/Admin1234)

# if needed, deletes the chart
helm uninstall keycloak -n authentication
```

## How to start once the application is running

* [Get started with Keycloak on Kubernetes](https://www.keycloak.org/getting-started/getting-started-kube)

## How to investigate

### Known issues

* Creating the secret at the same time as the chart may cause issue, create the secret first

* Rancher is not compatible with Quarkus ([Keycloak 17.0.0](https://www.keycloak.org/2022/02/keycloak-1700-released.html))
  * [Migrating to Quarkus distribution](https://www.keycloak.org/migration/migrating-to-quarkus)
  * [Rancher issue #38625](https://github.com/rancher/rancher/issues/38625) ([Rancher PR #38822](https://github.com/rancher/rancher/pull/38822))
