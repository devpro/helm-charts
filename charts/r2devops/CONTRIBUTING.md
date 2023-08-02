# Contribute

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add r2devops https://charts.r2devops.io
helm repo update

# searches for the latest version
helm search repo -l r2devops --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to check the manifest code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template r2devops . -f values.yaml --namespace r2devops-beta > temp.yaml
```

## How to deploy the chart from the sources

### Example with NGINX Ingress Controller and sslip.io

```bash
# gets Ingress Controller external IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# manual steps: follow https://github.com/r2devops/self-managed/blob/main/charts/r2devops/CONTIBUTING.md

# installs on a cluster
helm upgrade --install r2devops . -f values.yaml --create-namespace \
--namespace r2devops-beta \
--debug

# manual step: open http://r2devops.${NGINX_PUBLIC_IP}.sslip.io/
```
