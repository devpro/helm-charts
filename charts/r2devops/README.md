# Helm chart for R2Devops

This Helm chart will install [R2Devops](https://r2devops.io/) in a Kubernetes cluster.
It is based on the [official Helm chart](https://charts.r2devops.io) ([code](https://github.com/r2devops/self-managed), [docs](https://docs.r2devops.io/self-managed/kubernetes/)).

## Usage

```bash
# if not already done, adds devpro repository in helm
helm repo add r2devops https://charts.r2devops.io
helm repo update

# installs the chart with default parameters
helm upgrade --install r2devops devpro/r2devops --create-namespace --namespace r2devops

# cleans up
helm uninstall r2devops -n r2devops
kubectl delete ns r2devops
```

## Going further

Look at [Contibuting](CONTRIBUTING.md) page.
