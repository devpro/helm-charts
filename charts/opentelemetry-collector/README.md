# Helm chart for OpenTelemetry Collector

This Helm chart will install [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/)
by using the [official Helm chart](https://github.com/open-telemetry/opentelemetry-helm-charts).

## How to use

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install opentelemetry-collector devpro/opentelemetry-collector --create-namespace \
  --namespace opentelemetry-collector

# watches the installation and checks all pods are running after some time
kubectl get pod -n opentelemetry-collector --watch
```

## How to create or update the chart

```bash
# update helm repositories
../../scripts/add_helm_repos.sh

# searches for the latest version
helm search repo -l open-telemetry/opentelemetry-collector

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually from the sources

```bash
# creates the release from the local files
helm upgrade --install opentelemetry-collector . -f values.yaml --create-namespace \
  --namespace opentelemetry-collector

# (optional) forwards port for local access
kubectl port-forward daemonsets/opentelemetry-collector-agent 4317:4317 -n opentelemetry-collector

# if needed, deletes the release
helm uninstall opentelemetry-collector -n opentelemetry-collector
kubectl delete ns opentelemetry-collector
```
