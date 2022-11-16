# MariaDB

This Helm chart will install [MariaDB Community Server](https://mariadb.com/products/community-server/) ([Helm](https://bitnami.com/stack/mariadb/helm)).

## How to update the chart

```bash
# (only once) adds bitnami helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# updates repository information
helm repo update

# lists available charts and get latest version of the chart
helm search repo mariadb

# (if needed) updates Chart.yaml with version

# updates Chart.lock (and downloads locally the charts)
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml --namespace sample-apps > temp.yaml
```

## How to deploy manually

```bash
# installs the chart with helm
helm upgrade --install --create-namespace \
  --set mariadb.global.storageClass=azurefile \
  --set mariadb.image.debug=true \
  -f values.yaml --namespace sample-apps mariadb .

# if needed, deletes the chart
helm delete mariadb -n sample-apps
```
