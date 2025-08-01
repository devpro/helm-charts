# Argo CD

Let's see how to run [Argo CD](https://argoproj.github.io/cd) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd):

- [values.yaml](https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# installs
helm upgrade --install argocd argo/argo-cd --namespace argocd --create-namespace

# uninstalls
helm uninstall argocd -n argocd
kubectl delete ns argocd
```
