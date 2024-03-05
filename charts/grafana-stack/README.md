# Helm chart for Grafana

This Helm chart will install [Grafana stack](https://grafana.com/about/grafana-stack/) ([GitHub org](https://github.com/grafana)) on a Kubernetes cluster.
It is based on the [community Helm charts](https://github.com/grafana/helm-charts).

Stack components:

- [Grafana](https://grafana.com/oss/grafana/) ([Deploy Grafana on Kubernetes](https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/))
- [Loki](https://grafana.com/oss/loki/) ([Install Grafana Loki with Helm](https://grafana.com/docs/loki/latest/setup/install/helm/))
- [Mimir](https://grafana.com/oss/mimir/) ([Get started with Grafana Mimir using the Helm chart](https://grafana.com/docs/helm-charts/mimir-distributed/latest/get-started-helm-charts/))
- [Tempo](https://grafana.com/oss/tempo/) ([Deploy Tempo with Helm](https://grafana.com/docs/tempo/latest/setup/helm-chart/))

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
helm search repo grafana/mimir-distributed

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```
