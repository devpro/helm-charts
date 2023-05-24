# Contribute

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# searches for the latest version
helm search repo postgresql

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to check the manifest before deployment

```bash
# makes sure the repository has been added and refreshed
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# searches for the latest version
helm search repo postgresql

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template prometheus . -f values.yaml \
  --namespace prometheus > temp.yaml
```

## How to check the chart

```bash
# applies the manifest on a cluster
helm upgrade --install prometheus . -f values.yaml --create-namespace \
  --namespace prometheus
  # --debug > output.yaml
```
