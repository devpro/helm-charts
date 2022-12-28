# Longhorn Helm chart

This Helm chart will install [Longhorn](https://longhorn.io/) ([docs](https://longhorn.io/docs/1.3.1/), [GitHub](https://github.com/longhorn/longhorn))
and is based from the [official Helm chart](https://longhorn.io/docs/1.3.1/deploy/install/install-with-helm/) ([code](https://github.com/longhorn/charts)).

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add longhorn https://charts.longhorn.io
helm repo update

# searches for the latest version
helm search repo -l longhorn

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

```bash
# checks the Kubernetes objects generated from the chart
helm template longhorn . -f values.yaml \
  --namespace rablonghornbitmq > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install longhorn . -f values.yaml --create-namespace \
  --namespace longhorn

# checks everything is ok
kubectl get pod -n longhorn

# if needed, deletes the chart
helm uninstall longhorn -n longhorn
```

## How to start once the application is running

TODO

## How to investigate

### Known issues

TODO
