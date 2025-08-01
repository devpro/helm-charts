# Epinio

Let's see how to run [Epinio](https://epinio.io/) ([docs.epinio.io](https://docs.epinio.io/)) in a Kubernetes cluster.

> Epinio is an application Platform.
> It deploys on Kubernetes and allows application developers and operators to work together without stepping on each others work.

## CLI

Download [`epinio` (Epinio CLI)](https://github.com/epinio/epinio/releases/).

## Configuration

We'll use the [official Helm chart](https://artifacthub.io/packages/helm/epinio/epinio):

- [values.yaml](https://github.com/epinio/helm-charts/blob/main/chart/epinio/values.yaml)

## Deployment

💡 `cert-manager` must be installed

```bash
# adds Helm chart repository
helm repo add epinio https://epinio.github.io/helm-charts
helm repo update

# installs
helm upgrade --install epinio epinio/epinio --namespace epinio --create-namespace

# uninstalls
helm uninstall epinio -n epinio
kubectl delete ns epinio
```

## Examples

### Kubernetes cluster with NGINX Ingress Controller, cert-manager and Let's Encrypt issuers

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs on a cluster
helm upgrade --install epinio epinio/epinio --namespace epinio --create-namespace \
  --set global.domain=${NGINX_PUBLIC_IP}.sslip.io \
  --set global.tlsIssuer=letsencrypt-prod \
  --set global.tlsIssuerEmail=<my_email_address>

# logs in Epinio (default password is "password")
epinio login -u admin 'https://epinio.${NGINX_PUBLIC_IP}.sslip.io'

# displays instance information
epinio settings show
```
