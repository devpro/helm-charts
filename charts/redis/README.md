# Helm chart for Redis

This Helm chart will install [Redis](https://redis.io/) ([code](https://github.com/redis/redis)) on a Kubernetes cluster.
It is based on [Bitnami's Helm chart](https://bitnami.com/stack/redis/helm) ([code](https://github.com/bitnami/charts/blob/main/bitnami/redis/README.md)).

## How to use

- With Helm (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install redis devpro/redis --create-namespace \
  --namespace redis

# checks all pods are running after some time
kubectl get pod -n redis
```

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# searches for the latest version
helm search repo -l redis --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template redis . -f values.yaml \
  --namespace redis > temp.yaml
```

## How to deploy manually from the sources

### Sample with a given password

```bash
# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install redis . -f values.yaml --create-namespace \
  --set redis.auth.password=secretpassword \
  --set redis.replica.replicaCount=1 \
  --namespace redis

# forwards service port for local access
kubectl port-forward service/redis-master 6379:6379 -n redis

# checks the service is up and running with redis-cli
sudo apt install redis-tools
redis-cli -a secretpassword

# cleans up
helm uninstall redis -n redis
kubectl delete ns redis
```
