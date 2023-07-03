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
# checks the Kubernetes objects generated from the chart
helm template postgresql . -f values.yaml \
  --namespace postgresql > temp.yaml
```

## How to check the chart

```bash
# applies the manifest on a cluster
helm upgrade --install postgresql . -f values.yaml --create-namespace \
  --set postgresql.auth.postgresPassword=secretpassword \
  --namespace postgresql
  # --debug > output.yaml
```
