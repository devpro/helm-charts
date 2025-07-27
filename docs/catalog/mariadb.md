# MariaDB

Let's see how to run [MariaDB Community Server](https://mariadb.com/products/community-server/) in a Kubernetes cluster.

## Configuration

We'll use the [Bitnami chart]([Helm](https://bitnami.com/stack/mariadb/helm)):

- [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/mariadb/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# installs
helm upgrade --install mariadb bitnami/mariadb --namespace mariadb --create-namespace

# uninstalls
helm uninstall mariadb -n mariadb
kubectl delete ns mariadb
```

## Examples

### Azure

```bash
# installs the chart with helm
helm upgrade --install mariadb bitnami/mariadb --namespace mariadb --create-namespace
  --set mariadb.global.storageClass=azureblob-fuse \
  --set mariadb.image.debug=true
```
