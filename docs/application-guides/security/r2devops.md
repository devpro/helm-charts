# R2Devops

Let's see how to run [R2Devops](https://r2devops.io/) in a Kubernetes cluster.

We'll use the [official Helm chart](https://charts.r2devops.io) ([code](https://github.com/r2devops/self-managed), [docs](https://docs.r2devops.io/docs/self-managed/kubernetes/)).

## Configuration

Create the `values.yaml` file to override [default parameters](https://github.com/r2devops/self-managed/blob/main/charts/r2devops/values.yaml).

## Deployment

Add Helm chart repository:

```bash
helm repo add r2devops https://charts.r2devops.io
helm repo update
```

Install the application:

```bash
helm upgrade --install r2devops r2devops/r2devops -f values.yaml --namespace r2devops --create-namespace
```

Uninstall and clean the cluster:

```bash
helm uninstall r2devops -n r2devops
kubectl delete ns r2devops
```
