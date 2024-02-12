# Helm chart for Grafana

This Helm chart will install [Grafana stack](https://grafana.com/about/grafana-stack/) ([GitHub org](https://github.com/grafana)) on a Kubernetes cluster.
It is based on the [community Helm charts](https://github.com/grafana/helm-charts).

See also:

- [CNCF Live Webinar: Intro to open source observability with Grafana, Prometheus, Loki, and Tempo](https://community.cncf.io/events/details/cncf-cncf-online-programs-presents-cncf-live-webinar-intro-to-open-source-observability-with-grafana-prometheus-loki-and-tempo/) - November 16, 2021

## How to use

```bash
# install with default parameters
helm upgrade --install grafana-stack devpro/grafana-stack --create-namespace --namespace grafana

# checks all pods are running after some time
kubectl get pod -n grafana
```

## How to update the chart

```bash
# searches for the latest version
helm search repo grafana/grafana
helm search repo grafana/loki
helm search repo grafana/tempo

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```
