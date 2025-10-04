# Helm chart for Devpro Sales Portal

This is the official Helm chart to install [Devpro Sales Portal](https://github.com/devpro/sales-portal) on a Kubernetes cluster.

## Getting started

Start with the [documentation](https://kwt.devpro.fr/custom-charts/sales-portal.html).

## Usage

Add [Helm](https://helm.sh) repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the application:

```bash
helm upgrade --install sales-portal devpro/sales-portal -f values.yaml --create-namespace --namespace sales-portal
```

Uninstall the chart and clean-up the cluster:

```bash
helm delete sales-portal
kubectl delete ns sales-portal
```

## Development

Look at the [Contributing guide](CONTRIBUTING.md).
