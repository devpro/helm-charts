# Helm chart for MinIO

This Helm chart will install [min.io](https://min.io/) ([code](https://github.com/minio/minio)) on a Kubernetes cluster.
It is based on [the official Helm chart](https://github.com/minio/minio/tree/master/helm/minio).

## Quick start

```bash
# if not already done, adds devpro repository in helm
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update

# installs the chart with default parameters
helm upgrade --install minio devpro/minio --create-namespace --namespace minio

# cleans up
helm uninstall minio -n minio
kubectl delete ns minio
```

## Going further

Look at [Contibuting](CONTRIBUTING.md) page.
