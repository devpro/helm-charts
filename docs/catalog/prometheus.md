# Prometheus

Let's see how to run [Prometheus](https://prometheus.io/) ([code](https://github.com/prometheus/prometheus)) in a Kubernetes cluster.

## Configuration

We'll use the [community Helm chart](https://prometheus-community.github.io/helm-charts/) ([code](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/README.md)):

- [values.yaml](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add prometheus-community  https://prometheus-community.github.io/helm-charts
helm repo update

# installs
helm upgrade --install prometheus prometheus-community/prometheus --namespace prometheus --create-namespace

# checks everything is ok
kubectl get pod -n prometheus

# uninstalls
helm uninstall prometheus -n prometheus
kubectl delete ns prometheus
```

## Examples

### Minimal installation with default parameters

Install the application:

```bash
helm upgrade --install prometheus prometheus-community/prometheus --namespace prometheus --create-namespace
```

Forward the service port for local access:

```bash
kubectl port-forward service/prometheus-server 9090:80 -n prometheus
```

Open in a browser [localhost:9090](http://localhost:9090/)
