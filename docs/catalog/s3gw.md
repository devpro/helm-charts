# s3gw

Let's see how to run [s3gw.io](https://s3gw.tech/) ([docs](https://docs.s3gw.tech/), [code](https://github.com/s3gw-tech/s3gw)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://docs.s3gw.tech/helm-charts) ([code](https://github.com/s3gw-tech/s3gw-charts):

- [values.yaml](https://github.com/s3gw-tech/s3gw-charts/blob/main/charts/s3gw/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add s3gw https://charts.s3gw.tech
helm repo update

# installs
helm upgrade --install s3gw s3gw/s3gw --namespace s3gw-system --create-namespace

# checks all pods are running
kubectl get pod -n s3gw-system --watch

# uninstalls
helm uninstall s3gw -n s3gw-system
kubectl delete ns s3gw-system
```

## Examples

### cert-manager, Traefic & Longhorn

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs the application
helm upgrade --install s3gw s3gw/s3gw --namespace s3gw-system --create-namespace \
  --set ui.publicDomain=s3gw-ui.${NGINX_PUBLIC_IP}.sslip.io \
  --set publicDomain=s3gw.${NGINX_PUBLIC_IP}.sslip.io \
  --set storageClass.name=longhorn \
  --set tlsIssuer=letsencrypt-prod
```
