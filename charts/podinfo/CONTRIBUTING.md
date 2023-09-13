# Contribute to Podinfo Helm chart

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update

# searches for the latest version
helm search repo -l podinfo --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to check the manifest code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart on a specific case defined in values_mine.yaml
helm template podinfo . -f values.yaml -f values_mine.yaml --namespace podinfo > temp.yaml
```

## How to deploy the chart from the sources

```bash
# installs on a cluster
helm upgrade --install podinfo . -f values.yaml --create-namespace \
  --namespace podinfo \
  # --debug
```
