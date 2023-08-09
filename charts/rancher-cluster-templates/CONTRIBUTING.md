# Contribution guide

## How to check the manifest code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart on a specific case defined in values_mine.yaml
helm template my-cluster . -f values.yaml -f values_mine.yaml --namespace fleet-default > temp.yaml
```

## How to deploy the chart from the sources

💡 This commands must be run on the Kubernetes cluster hosting Rancher (called `local` by default).

### Example with a cluster on Azure

```bash
# copies the example

```bash
cp examples/values_azure.yaml values_mine.yaml
resourcekey=$(openssl rand -hex 6)
sed -i "s/CLUSTER_NAME/az-rke2-$resourcekey/g" values_mine.yaml
sed -i "s/AZURE_PREFIX/$USER-$resourcekey/g" values_mine.yaml
sed -i "s/CLOUD_CREDENTIAL_SECRET/<secret_name>/g" values_mine.yaml

# runs the installation with Helm
helm upgrade --install rke2-azure-cluster01 . -f values.yaml -f values_mine.yaml --namespace fleet-default

# removes the installation
helm uninstall rke2-azure-cluster01 -n fleet-default
```
