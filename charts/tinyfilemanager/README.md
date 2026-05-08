# Tiny File Manager Helm Chart

Helm chart for [Tiny File Manager](https://tinyfilemanager.github.io/) — designed for container security workshops.

## Quick Start

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the chart:

```bash
helm upgrade --install tinyfilemanager devpro/nextportal -f values.yaml --namespace tinyfilemanager --create-namespace
```

## Uninstall

```bash
helm uninstall tinyfilemanager -n tinyfilemanager
kubectl delete namespace tinyfilemanager
```

## Going further

Check the [contribution guide](CONTRIBUTING.md).

---
> ⚠️ **FOR WORKSHOP USE ONLY** — intentionally vulnerable, never expose to the internet.
