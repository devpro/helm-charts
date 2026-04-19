# Drupal Helm Chart

Helm chart for Drupal — designed for container security workshops.

## Quick Start

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the chart:

```bash
helm upgrade --install drupal devpro/drupal -f values.yaml --namespace drupal --create-namespace
```

## Uninstall

```bash
helm uninstall drupal -n drupal
kubectl delete namespace drupal
```

## Going further

Check the [contribution guide](CONTRIBUTING.md).

---
> ⚠️ **FOR WORKSHOP USE ONLY** — intentionally vulnerable, never expose to the internet.
