# Redis

Let's see how to run [Redis](https://redis.io/) ([code](https://github.com/redis/redis)) in a Kubernetes cluster.

## Configuration

We'll use the [Bitnami's Helm chart](https://bitnami.com/stack/redis/helm) ([code](https://github.com/bitnami/charts/blob/main/bitnami/redis/README.md)):

- [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/redis/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# installs
helm upgrade --install redis bitnami/redis --namespace redis --create-namespace

# checks all pods are running
kubectl get pod -n redis

# uninstalls
helm uninstall redis -n redis
kubectl delete ns redis
```

## Examples

### Single instance, given password

```bash
# applies the manifest
helm upgrade --install redis bitnami/redis --namespace redis --create-namespace \
  --set redis.auth.password=secretpassword \
  --set redis.replica.replicaCount=1

# forwards service port for local access
kubectl port-forward service/redis-master 6379:6379 -n redis

# checks the service is up and running with redis-cli
sudo apt install redis-tools
redis-cli -a secretpassword
```
