# Helm chart for NATS

This Helm chart will install [nats.io](https://nats.io/) on a Kubernetes cluster ([NATS](https://github.com/nats-io)).
It is based on the [official charts](https://github.com/nats-io/k8s) ([code](https://github.com/nats-io/k8s/tree/main/helm/charts/nats)).

NATS is the "simple, secure and performant communications system and data layer for digital systems, services and devices".

## Quick start

- Add Helm repositories

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

- Initiate `values_mine.yaml` from [values.yaml](values.yaml) and configure the database(s) to be created

- Install NATS

```bash
helm upgrade --install nats devpro/nats -f values_mine.yaml --namespace nats
```

- Clean-up

```bash
helm uninstall nats -n nats
kubectl delete ns nats
```

## Going further

Look at the [Contributing](CONTRIBUTING.md) page.
