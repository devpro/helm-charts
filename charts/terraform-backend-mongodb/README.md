# Helm chart for Terraform Backend MongoDB

This Helm chart will deploy [Terraform Backend MongoDB](https://github.com/devpro/terraform-backend-mongodb) on a Kubernetes cluster.

## Getting started

Start with the [documentation](https://kwt.devpro.fr/custom-charts/terraform-backend-mongodb.html).

## Usage

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the application:

```bash
helm upgrade --install tfbackend devpro/terraform-backend-mongodb -f values.yaml --namespace tfbackend --create-namespace
```

## Going further

Check the [contribution guide](CONTRIBUTING.md).
