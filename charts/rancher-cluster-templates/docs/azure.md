# Azure Cloud

## Design

* [Availability sets overview](https://learn.microsoft.com/en-us/azure/virtual-machines/availability-set-overview)
* [Azure Virtual Network concepts and best practices](https://learn.microsoft.com/en-us/azure/virtual-network/concepts-and-best-practices)
* [General purpose virtual machine sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-general)

## Configuration

* Find image reference (ref. [Find Azure Marketplace image information using the Azure CLI](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage))

```bash
# displays popular images
az vm image list --output table

# lists Ubuntu 20.04 images
az vm image list --all --publisher="Canonical" --sku="20_04-lts-gen2"
```

## Troubleshooting

* Open Monitor in Azure Portal, and look in Activity log for operations in error
  * Click on the operation to see the detail of the error
