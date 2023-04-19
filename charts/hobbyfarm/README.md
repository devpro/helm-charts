# Helm chart for HobbyFarm

This Helm chart will install [HobbyFarm](https://hobbyfarm.github.io/) ([code](https://github.com/hobbyfarm))
and is based from the [official Helm chart](https://hobbyfarm.github.io/hobbyfarm/) ([code](https://github.com/hobbyfarm/hobbyfarm)).

## How to use

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install hobbyfarm devpro/hobbyfarm --create-namespace \
  --namespace hobbyfarm

# checks all pods are running after some time
kubectl get pod -n hobbyfarm

# if needed, deletes the chart
helm uninstall hobbyfarm -n hobbyfarm
kubectl delete ns hobbyfarm
```

## How to start once the application is running

- Open HobbyFarm Admin UI, for example "https://admin.hobbyfarm.${NGINX_PUBLIC_IP}.sslip.io/"
- Open HobbyFarm UI, for example "https://learn.hobbyfarm.${NGINX_PUBLIC_IP}.sslip.io/"

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add hobbyfarm https://hobbyfarm.github.io/hobbyfarm

# searches for the latest version
helm search repo -l hobbyfarm

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template hobbyfarm . -f values.yaml \
  --namespace hobbyfarm > temp.yaml
```

## How to deploy manually from the sources

### Sample with cert-manager, Let's Encrypt & NGINX Ingress Controller

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install hobbyfarm-beta . -f values.yaml --create-namespace \
  --set hobbyfarm.ingress.enabled=true \
  --set hobbyfarm.ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set hobbyfarm.ingress.className=nginx \
  --set hobbyfarm.ingress.tls.enabled=true \
  --set hobbyfarm.ingress.tls.secrets.admin=hf-admin-tls \
  --set hobbyfarm.ingress.tls.secrets.backend=hf-backend-tls \
  --set hobbyfarm.ingress.tls.secrets.shell=hf-shell-tls \
  --set hobbyfarm.ingress.tls.secrets.ui=hf-ui-tls \
  --set hobbyfarm.ingress.hostnames.admin=admin.hf.${NGINX_PUBLIC_IP}.sslip.io \
  --set hobbyfarm.ingress.hostnames.backend=api.hf.${NGINX_PUBLIC_IP}.sslip.io \
  --set hobbyfarm.ingress.hostnames.shell=shell.hf.${NGINX_PUBLIC_IP}.sslip.io \
  --set hobbyfarm.ingress.hostnames.ui=learn.hf.${NGINX_PUBLIC_IP}.sslip.io \
  --set hobbyfarm.terraform.enabled=false \
  --set hobbyfarm.users.admin.enabled=true \
  --namespace hobbyfarm-beta
```
