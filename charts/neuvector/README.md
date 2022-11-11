# NeuVector

This Helm chart will install [NeuVector](https://github.com/neuvector/neuvector) ([GitHub](https://github.com/neuvector/neuvector-helm)).

## How to update the chart

```bash
# (only once) adds official chart repository
 helm repo add neuvector https://neuvector.github.io/neuvector-helm/

# updates repository information
helm repo update

# lists available charts
helm search repo neuvector

# updates Chart.yaml with the lastest version available
```

## How to deploy manually

```bash
# installs locally the related charts
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml --namespace neuvector > temp.yaml

# installs the chart with helm
helm install -f values.yaml --namespace neuvector neuvector .

# watchs the service being created and assigned a public IP
# TODO

# if needed, deletes the chart
helm delete neuvector -n neuvector
```
