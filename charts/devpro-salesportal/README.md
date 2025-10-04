# Helm chart for Devpro Sales Portal

This Helm chart will install [Devpro Sales Portal](https://github.com/devpro/sales-portal) on a Kubernetes cluster.

## Usage

Add [Helm](https://helm.sh) repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Install the application:

```bash
helm upgrade --install sales-portal devpro/sales-portal --create-namespace --namespace sales-portal
```

Uninstall the chart and clean-up the cluster:

```bash
helm delete sales-portal
kubectl delete ns sales-portal
```

## Development

Look at the [Contributing guide](CONTRIBUTING.md).
