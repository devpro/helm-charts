# NGINX Ingress Controller

Let's see how to run [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/) ([GitHub](https://github.com/kubernetes/ingress-nginx/)) in a Kubernetes cluster.

## Configuration

We'll use the official Helm chart:

- [values.yaml](https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml)

## Deployment

💡 Kubernetes objects should be installed in `ingress-nginx` namespace

```bash
# adds Helm chart repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# installs
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

# watchs the service being created and assigned a public IP (it can take time if the cloud provider is called to create a load balancer/ip address)
kubectl get services -o wide -w ingress-nginx-controller --namespace ingress-nginx

# stores the ip address (that may be dynamic/generated)
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# uninstalls
helm uninstall ingress-nginx -n ingress-nginx
kubectl delete ns ingress-nginx
```
