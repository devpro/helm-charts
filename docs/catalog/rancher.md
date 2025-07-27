# Rancher

Let's see how to run [Rancher](https://www.rancher.com/) ([docs](https://docs.ranchermanager.rancher.io/), [code](https://github.com/rancher/rancher)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://github.com/rancher/rancher/tree/release/v2.12/chart) ([docs]((https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster))):

- [values.yaml](https://github.com/rancher/rancher/blob/release/v2.12/chart/values.yaml)

## Deployment

💡 Kubernetes objects will be installed in `cattle-system` namespace

```bash
# adds Helm chart repository
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update

# installs
helm upgrade --install rancher rancher-latest/rancher --namespace cattle-system --create-namespace

# checks everything is ok
kubectl get svc,deploy,pod,ingress,pv,certificate -n cattle-system

# retrieves generated password
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{ .data.bootstrapPassword|base64decode}}{{ "\n" }}'

# uninstalls
helm uninstall rancher -n cattle-system
kubectl delete ns cattle-system
```

## Examples

### cert-manager, NGINX

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs the application
helm upgrade --install rancher rancher-latest/rancher --namespace cattle-system --create-namespace \
  --set rancher.replicas=2 \
  --set hostname=rancher.${NGINX_PUBLIC_IP}.sslip.io \
  --set ingress.extraAnnotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set ingress.ingressClassName=nginx \
  --set ingress.tls.source=secret \
  --set ingress.tls.secretName=rancher-tls
```
