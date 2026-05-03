# Trackboard Helm Chart

Helm chart for [Trackboard Web Application](https://github.com/devpro/container-images/tree/main/src/trackboard) — designed for container security workshops.

## Quick Start

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the chart:

```bash
helm upgrade --install trackboard devpro/trackboard -f values.yaml --namespace trackboard --create-namespace
```

## Uninstall

```bash
helm uninstall trackboard -n trackboard
kubectl delete namespace trackboard
```

## Going further

Check the [contribution guide](CONTRIBUTING.md).

---
> ⚠️ **FOR WORKSHOP USE ONLY** — intentionally vulnerable, never expose to the internet.
