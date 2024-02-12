# Helm chart for Prometheus

This Helm chart will install [Prometheus](https://prometheus.io/) ([code](https://github.com/prometheus/prometheus)) on a Kubernetes cluster.
It is based on the [community Helm chart](https://prometheus-community.github.io/helm-charts/) ([code](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/README.md)).

See [README](../../README.md#from-helm-cli) for requirements.

## How to use

```bash
# install with default parameters
helm upgrade --install prometheus devpro/prometheus --create-namespace \
--namespace prometheus

# checks all pods are running after some time
kubectl get pod -n prometheus
```

## How to create or update the chart

```bash
# searches for the latest version
helm search repo prometheus-community

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template prometheus . -f values.yaml \
--namespace prometheus > temp.yaml
```

## How to deploy manually from the sources

### Sample with a given password

```bash
# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install prometheus . -f values.yaml --create-namespace \
--namespace prometheus

# forwards service port for local access
kubectl port-forward service/prometheus-server 9090:80 -n prometheus

# accesses prometheus server UI with http://localhost:9090/
curl http://localhost:9090/

# cleans up
helm uninstall prometheus -n prometheus
kubectl delete ns prometheus
```
