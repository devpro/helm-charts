# NGINX Ingress Controller

This Helm chart will install [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/) ([GitHub](https://github.com/kubernetes/ingress-nginx/)).

## How to update the chart

```bash
# (only once) adds ingress-nginx helm chart repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# updates repository information
helm repo update

# lists available charts and get latest version of the chart
helm search repo ingress-nginx

# (if needed) updates Chart.yaml with version

# updates Chart.lock (and downloads locally the charts)
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml --namespace ingress-nginx > temp.yaml
```

## How to deploy manually

```bash
# installs the chart with helm
helm upgrade --install -f values.yaml --namespace ingress-nginx ingress-nginx .

# watchs the service being created and assigned a public IP (it can take time if the cloud provider is called to create a load balancer/ip address)
kubectl get services -o wide -w ingress-nginx-controller --namespace ingress-nginx

# stores the ip address (that may be dynamic/generated)
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# if needed, deletes the chart
helm delete ingress-nginx -n ingress-nginx
```
