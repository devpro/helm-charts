# Helm chart for Terraform Backend MongoDB

This Helm chart will deploy [Terraform Backend MongoDB](https://github.com/devpro/terraform-backend-mongodb) on a Kubernetes cluster.

## Usage

Add [Helm](https://helm.sh) repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Install the chart:

```bash
helm upgrade --install tfbackend devpro/terraform-backend-mongodb --create-namespace --namespace tfbackend
```

Uninstall the chart:

```bash
helm delete tfbackend
kubectl delete ns tfbackend
```

More information on the [contribution guide](CONTRIBUTING.md).
