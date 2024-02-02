# Contribute

## How to check the manifest before deployment

```bash
# checks the Kubernetes objects generated from the chart
helm template nfs-ganesha . -f values.yaml \
--namespace nfs-ganesha > temp.yaml
```

## How to check the chart

```bash
# applies the manifest on a cluster
helm upgrade --install nfs-ganesha . -f values.yaml --create-namespace \
--namespace nfs-ganesha
# --debug > output.yaml
```
