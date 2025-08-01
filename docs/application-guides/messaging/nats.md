# NATS

Let's see how to run [nats.io](https://nats.io/) ([GitHub](https://github.com/nats-io)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://github.com/nats-io/k8s) ([code](https://github.com/nats-io/k8s/tree/main/helm/charts/nats)):

- [values.yaml](https://github.com/nats-io/k8s/blob/main/helm/charts/nats/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add nats https://nats-io.github.io/k8s/helm/charts
helm repo update

# installs
helm upgrade --install nats nats/nats --namespace nats --create-namespace

# uninstalls
helm uninstall nats -n nats
kubectl delete ns nats
```
