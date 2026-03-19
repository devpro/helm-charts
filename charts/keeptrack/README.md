# Helm chart for Devpro Keeptrack

This is the official Helm chart to install [Keeptrack](https://github.com/devpro/keeptrack) on a Kubernetes cluster.

## Getting started

Start with the [documentation](https://kwt.devpro.fr/custom-charts/keeptrack.html).

## Usage

Add [Helm](https://helm.sh) repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the application:

```bash
helm upgrade --install keeptrack devpro/keeptrack -f values.yaml --create-namespace --namespace keeptrack
```

Uninstall the chart and clean-up the cluster:

```bash
helm delete keeptrack
kubectl delete ns keeptrack
```

## Development

Look at the [Contributing guide](CONTRIBUTING.md).
