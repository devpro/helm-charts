# Helm chart for Kasten K10

This Helm chart will install [Kasten K10](https://www.kasten.io/product/) ([docs](https://docs.kasten.io/latest/index.html))
and is based from the [official Helm chart](https://docs.kasten.io/latest/install/other/other.html)

⚠ Kasten K10 is not open source

ℹ Kasten K10 is free for up to 5 nodes

## How to use

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install k10 devpro/kasten-k10 --create-namespace \
  --namespace kasten-io

# watches the installation and checks all pods are running after some time
kubectl get pods --namespace kasten-io --watch

# if needed, deletes the chart
helm uninstall k10 -n kasten-io
kubectl delete ns kasten-io
```

## How to start

- Access the dashboard with a port forward

```bash
kubectl --namespace kasten-io port-forward service/gateway 8080:8000

# manual: the K10 dashboard will be available at http://127.0.0.1:8080/k10/#/
```

## How to create or update

```bash
# adds helm chart repository
helm repo add kasten https://charts.kasten.io

# searches for the latest version
helm search repo -l k10

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template k10 . -f values.yaml \
  --namespace kasten-io > temp.yaml
```

## How to deploy manually from the sources

### Sample with default options

```bash
# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install k10 . -f values.yaml --create-namespace \
  --namespace kasten-io
```
