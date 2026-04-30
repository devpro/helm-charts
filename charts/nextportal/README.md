# NextPortal Helm Chart

Helm chart for [NextPortal Web Application](https://github.com/devpro/container-images/tree/main/src/nextportal) — designed for container security workshops.

## Quick Start

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the chart:

```bash
helm upgrade --install nextportal devpro/nextportal -f values.yaml --namespace nextportal --create-namespace
```

## Uninstall

```bash
helm uninstall nextportal -n nextportal
kubectl delete namespace nextportal
```

## Going further

Check the [contribution guide](CONTRIBUTING.md).

---
> ⚠️ **FOR WORKSHOP USE ONLY** — intentionally vulnerable, never expose to the internet.
