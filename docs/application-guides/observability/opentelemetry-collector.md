# OpenTelemetry Collector

Let's see how to run [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/) in a Kubernetes cluster.

> [!NOTE]
> [OpenTelemetry Collector Contrib](https://github.com/open-telemetry/opentelemetry-collector-contrib) will be installed by default

## Repository

We'll use the [official Helm chart](https://github.com/open-telemetry/opentelemetry-helm-charts):

```bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
```

## Configuration

Create the `values.yaml` file to override [default parameters](https://github.com/open-telemetry/opentelemetry-helm-charts/blob/main/charts/opentelemetry-collector/values.yaml).

::: code-group

```yaml [Daemonset]
opentelemetry-collector:
  mode: daemonset
  config:
    receivers:
      jaeger: null
      zipkin: null
    service:
      pipelines:
        logs:
          exporters:
            - logging
          processors:
            - memory_limiter
            - batch
          receivers:
            - otlp
        metrics:
          exporters:
            - logging
          processors:
            - memory_limiter
            - batch
          receivers:
            - otlp
            # - prometheus
        traces:
          exporters:
            - logging
          processors:
            - memory_limiter
            - batch
          receivers:
            - otlp
  ports:
    jaeger-compact:
      enabled: false
    jaeger-thrift:
      enabled: false
    jaeger-grpc:
      enabled: false
    zipkin:
      enabled: false
```

:::

## Deployment

Install the application:

```bash
helm upgrade --install otel-collector open-telemetry/opentelemetry-collector -f values.yaml --namespace otel-collector --create-namespace
```

Watch objects being created:

```bash
kubectl get pod -n opentelemetry-collector --watch
```

## Optional check

Forwards port for local access:

```bash
kubectl port-forward daemonsets/opentelemetry-collector-agent 4317:4317 -n opentelemetry-collector
```

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm uninstall otel-collector -n otel-collector
kubectl delete ns otel-collector
```
