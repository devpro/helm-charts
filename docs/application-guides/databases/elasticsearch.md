# Elasticsearch

Let's see how to run [Elasticsearch](https://www.elastic.co/elasticsearch/) ([docs](https://www.elastic.co/guide/index.html), [code](https://github.com/elastic/elasticsearch)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://artifacthub.io/packages/helm/elastic/elasticsearch) ([code](https://github.com/reportportal/kubernetes)):

- [values.yaml](https://github.com/elastic/helm-charts/blob/main/elasticsearch/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add elastic https://helm.elastic.co
helm repo update

# installs
helm upgrade --install elasticsearch elastic/elasticsearch --namespace elasticsearch --create-namespace

# checks everything is ok
kubectl get pod -n elasticsearch

# uninstalls
helm uninstall elasticsearch -n elasticsearch
kubectl delete ns elasticsearch
```
