# NGINX Ingress Controller

This Helm chart installs NGINX Ingress Controller in a Kubernetes cluster. It can be ran from Helm or used in a GitOps approach (with ArgoCD or Rancher Fleet for example).

See [kubernetes.github.io/ingress-nginx](https://kubernetes.github.io/ingress-nginx/), [kubernetes/ingress-nginx](https://github.com/kubernetes/ingress-nginx/)

## How to update the chart

```bash
# (only once) adds ingress-nginx helm chart repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# updates repository information
helm repo update

# lists available charts
helm search repo ingress-nginx

# updates Chart.yaml with the lastest version available
```

## How to deploy manually

```bash
# installs locally the related charts
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml --namespace fleet-sample > temp.yaml

# installs the chart with helm
helm install -f values.yaml --namespace fleet-sample nginx-ingress .

# watchs the service being created and assigned a public IP
kubectl get services -o wide -w nginx-ingress-ingress-nginx-controller --namespace fleet-sample

# if needed, deletes the chart
helm delete nginx-ingress -n fleet-sample
```
