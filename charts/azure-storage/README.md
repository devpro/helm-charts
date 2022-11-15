# Azure Storage

This Helm chart will install the Kubernetes objects to be able to use Azure storage, to be able to create persistent volume claims.

## How to create a storage account

* With [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) (see the full procedure on [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-cli))

```bash
az storage account create --name <staname> --resource-group <rg_name> --location westeurope --sku Standard_LRS --kind StorageV2
```

## How to update the chart

```bash
# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml > temp.yaml
```

## How to deploy manually

```bash
# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install -f values.yaml --create-namespace \
  --set azureFile.enabled=true \
  --set azureFile.isDefault=true \
  --set azureFile.skuName=Standard_LRS \
  --set azureFile.location=westeurope \
  --set azureFile.storageAccount=<staname> \
  --namespace kube-system azure-storage .

# if needed, deletes the chart
helm delete cert-manager -n cert-manager
```

## How to investigate

```bash
# checks existings resources
kubectl get sc
```
