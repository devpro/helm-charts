# Azure Storage

This Helm chart will install the Kubernetes objects to be able to use Azure storage, to be able to create persistent volume claims.

💡 Kubernetes objects will be installed in `kube-system` namespace

## What is installed

* [Azure File Storage class (with RBAC)](https://kubernetes.io/docs/concepts/storage/storage-classes/#azure-file)
* [Azure CSI (Container Storage Interface) drivers](https://learn.microsoft.com/en-us/azure/aks/csi-storage-drivers)
  * [Azure Disk CSI driver](https://github.com/kubernetes-sigs/azuredisk-csi-driver) ([Helm chart](https://github.com/kubernetes-sigs/azuredisk-csi-driver/tree/master/charts))
    * [CSI driver example](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/deploy/example/e2e_usage.md)
  * [Azure Blob Storage CSI driver](https://github.com/kubernetes-sigs/blob-csi-driver) ([Helm chart](https://github.com/kubernetes-sigs/blob-csi-driver/tree/master/charts))

## How to get chart values

### SKU (Stock Keeping Unit)

* [SKU Types](https://learn.microsoft.com/en-us/rest/api/storagerp/srp_sku_types)

### Azure Storage account

* With [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) (see the full procedure on [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-cli))

```bash
az storage account create --name <staname> --resource-group <rg_name> --location westeurope --sku Standard_LRS --kind StorageV2
```

### Azure Cloud Config encrypted data

💡 Azure Cloud Config is needed by Azure CSI drivers and We can make it available in the container as a secret (see [Read cloud config from Kubernetes secrets](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/read-from-secret.md))

* Create `azure.json` file locally ([example](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/deploy/example/azure.json))

```json
{
  "cloud":"AzurePublicCloud",
  "tenantId": "xxxx",
  "aadClientId": "xxxx",
  "aadClientSecret": "xxxx",
  "subscriptionId": "xxxx",
  "resourceGroup": "rg-xxxx",
  "location": "westeurope",
  "subnetName": "sub-xxxx",
  "securityGroupName": "nsg-xxxx",
  "securityGroupResourceGroup": "rg-xxxx",
  "vnetName": "vnet-xxxx",
  "vnetResourceGroup": "rg-xxxx",
  "primaryAvailabilitySetName": "avs-xxxx",
  "routeTableResourceGroup": "rg-xxxx",
  "cloudProviderBackoff": false,
  "useManagedIdentityExtension": false,
  "useInstanceMetadata": true
}
```

* Get base64 encoding value

```bash
cloud_config_base64=$(cat azure.json | base64 | awk '{printf $0}')
```

* Get encrypted value from kubeseal output (spec.encrypteData.cloud-config)

```bash
cat <<EOF | kubeseal -o yaml
apiVersion: v1
kind: Secret
metadata:
  name: azure-cloud-provider
  namespace: kube-system
type: Opaque
data:
  cloud-config: $cloud_config_base64
EOF
```

## How to update the chart

```bash
# adds helm chart repository
helm repo add azuredisk-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts
helm repo add blob-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/blob-csi-driver/master/charts
helm repo update

# searches for the latest version
helm search repo -l azuredisk-csi-driver
helm search repo -l blob-csi-driver

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

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
  --set annotations."storageclass\.kubernetes\.io/is-default-class"="\"true\""
  --namespace kube-system azure-storage .

# checks everything is ok
kubectl --namespace=kube-system get pods --selector="release=azure-storage" --watch

# if needed, deletes the chart
helm uninstall azure-storage -n kube-system
```

## How to investigate

```bash
# checks existings resources
kubectl get sc,clusterrole,clusterrolebinding | grep azure
```
