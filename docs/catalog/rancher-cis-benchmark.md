# Rancher CIS Benchmark

Let's see how to run Rancher CIS Benchmark in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://github.com/rancher/charts/tree/release-v2.9/charts/rancher-cis-benchmark):

- [values.yaml](https://github.com/rancher/charts/blob/release-v2.9/charts/rancher-cis-benchmark/6.8.0/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add rancher-charts https://charts.rancher.io
helm repo update

# installs
helm upgrade --install rancher-cis-benchmark rancher-charts/rancher-cis-benchmark --namespace cis-operator-system --create-namespace

# uninstalls
helm uninstall rancher-cis-benchmark -n cis-operator-system
kubectl delete ns cis-operator-system
```
