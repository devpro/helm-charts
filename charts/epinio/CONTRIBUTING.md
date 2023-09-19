# Contribute to Epinio Helm chart

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add epinio https://epinio.github.io/helm-charts
helm repo update

# searches for the latest version
helm search repo -l epinio --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to check the manifest code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template epinio . -f values.yaml --namespace epinio > temp.yaml
```

## How to deploy the chart from the sources

### With NGINX Ingress Controller and Let's Encrypt

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs on a cluster
helm upgrade --install epinio . -f values.yaml --create-namespace \
--set epinio.global.domain=${NGINX_PUBLIC_IP}.sslip.io \
--set epinio.global.tlsIssuer=letsencrypt-prod \
--set epinio.global.tlsIssuerEmail=<my_email_address> \
--namespace epinio

# logs in Epinio (default password is "password")
epinio login -u admin 'https://epinio.${NGINX_PUBLIC_IP}.sslip.io'

# displays instance information
epinio settings show
```
