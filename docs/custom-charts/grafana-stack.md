# Grafana stack

Let's see how to run [Grafana stack](https://grafana.com/about/grafana-stack/) ([GitHub](https://github.com/grafana)) in a Kubernetes cluster.

## Repository

This is a custom chart based on the [community Helm charts](https://github.com/grafana/helm-charts):

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

## Configuration

Create the `values.yaml` file to override [default parameters](https://github.com/devpro/helm-charts/blob/main/charts/grafana-stack/values.yaml).

::: code-group

```yaml [Ingress]
grafana:
  # https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    hosts:
      - grafana.somedomain
    tls:
      - secretName: grafana-tls
        hosts:
          - grafana.somedomain
```

:::

## Deployment

Install the application:

```bash
helm upgrade --install grafana-stack devpro/grafana-stack  -f values.yaml --namespace grafana --create-namespace
```

Watch objects being created:

```bash
kubectl get pod -n grafana
```

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm uninstall grafana-stack -n grafana
kubectl delete ns grafana
```
