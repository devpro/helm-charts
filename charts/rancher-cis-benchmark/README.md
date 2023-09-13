# Rancher CIS Benchmark

## How to update the chart

```bash
# adds helm chart repository
helm repo add rancher-charts https://charts.rancher.io
helm repo update

# searches for the latest version
helm search repo -l rancher-cis-benchmark

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```
