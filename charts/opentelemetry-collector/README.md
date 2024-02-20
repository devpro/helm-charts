# Helm chart for OpenTelemetry Collector

This Helm chart will install [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/)
by using the [official Helm chart](https://github.com/open-telemetry/opentelemetry-helm-charts).

💡 By default, [OpenTelemetry Collector Contrib](https://github.com/open-telemetry/opentelemetry-collector-contrib) will be installed (which is a good think 😊)

## How to use

- Review the default configuration from [values.yaml](values.yaml) and identify the changes specific to your environment

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with optional parameters
helm upgrade --install opentelemetry-collector devpro/opentelemetry-collector --create-namespace \
--namespace opentelemetry-collector
# --set myvariable=xxx
# -f myvalues.yaml

# watches the installation and checks all pods are running after some time
kubectl get pod -n opentelemetry-collector --watch
```

## How to create or update the chart

```bash
# adds & updates upstream repository
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

# searches for the latest version
helm search repo -l open-telemetry/opentelemetry-collector

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually from the sources

```bash
# creates the release from the local files
kubectl create ns opentelemetry-collector
helm upgrade --install opentelemetry-collector . -f values.yaml --namespace opentelemetry-collector

# (optional) forwards port for local access
kubectl port-forward daemonsets/opentelemetry-collector-agent 4317:4317 -n opentelemetry-collector

# if needed, deletes the release
helm uninstall opentelemetry-collector -n opentelemetry-collector
kubectl delete ns opentelemetry-collector
```
