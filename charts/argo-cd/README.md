# ArgoCD

This Helm chart will install [ArgoCD](https://argoproj.github.io/cd) and is based from the [official Helm chart](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd).

## How to update the chart

```bash
# adds helm chart repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# searches for the latest version
helm search repo -l argo-cd

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml > temp.yaml
```

## How to deploy manually

```bash
# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install -f values.yaml --create-namespace \
  --namespace argocd argocd .

# checks everything is ok
#TODO

# if needed, deletes the chart
helm uninstall argocd -n argocd
```

## How to investigate

```bash
# checks existings resources
#TODO
```
