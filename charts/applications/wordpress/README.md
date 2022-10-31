# WordPress

This Helm chart will install [WordPress packaged by Bitnami](https://bitnami.com/stack/wordpress/helm) ([GitHub](https://github.com/bitnami/charts/tree/main/bitnami/wordpress)).

## How to update the chart

```bash
# (only once) adds bitnami helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# updates repository information
helm repo update

# lists available charts
helm search repo wordpress

# updates Chart.yaml with the lastest version available
```

## How to deploy manually

```bash
# installs locally the related charts
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml --namespace sample > temp.yaml

# installs the chart with helm
helm install -f values.yaml --namespace sample nginx-ingress .

# watchs the service being created and assigned a public IP
kubectl get services -o wide -w nginx-ingress-ingress-nginx-controller --namespace sample

# if needed, deletes the chart
helm delete nginx-ingress -n sample
```
