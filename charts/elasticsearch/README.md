# Helm chart for Elasticsearch

This Helm chart will install [Elasticsearch](https://www.elastic.co/elasticsearch/) ([docs](https://www.elastic.co/guide/index.html), [code](https://github.com/elastic/elasticsearch))
and is based from the [official Helm chart](https://artifacthub.io/packages/helm/elastic/elasticsearch) ([code](https://github.com/reportportal/kubernetes)).

## How to use

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install elasticsearch devpro/elasticsearch --create-namespace \
  --namespace elasticsearch

# checks all pods are running after some time
kubectl get pod -n elasticsearch

# if needed, deletes the chart
helm uninstall elasticsearch -n elasticsearch
kubectl delete ns elasticsearch
```

## How to start once the application is running

👷 TODO

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add elastic https://helm.elastic.co

# searches for the latest version
helm search repo -l elasticsearch

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template elasticsearch . -f values.yaml \
  --namespace elasticsearch > temp.yaml
```

## How to deploy manually from the sources

👷 TODO
