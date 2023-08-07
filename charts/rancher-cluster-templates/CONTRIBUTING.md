# Contribution guide

This command lines must be run on `local` Kubernetes cluster hosting Rancher.

## How to check the manifest code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template my-cluster . -f values.yaml --namespace fleet-default > temp.yaml
```

## How to deploy the chart from the sources

### Example with a cluster on Azure

```bash
helm install rke2-azure-cluster01 . -f values.yaml --namespace fleet-default
```
