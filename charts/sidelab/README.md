# Sidelab Helm Chart

Helm chart for Sidelab, a self-hosted interactive lab platform.

## Quick Start

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
helm upgrade --install sidelab devpro/sidelab \
  --set image.repository=<registry>/sidelab-launcher \
  --namespace sidelab --create-namespace
```

> **Tip:** Every option is documented in [values.yaml](values.yaml).

## Uninstall

```bash
helm uninstall sidelab -n sidelab
kubectl delete namespace sidelab
```

> **Note:**  Deleting the namespace deletes the generated `<release>-auth` Secret and the data volume.

## Fallstar

`fallstar.yaml` describes the choices of a deployment (database, secrets, lab access, TLS) and the values each one implies, for [Fallstar](https://github.com/devpro/fallstar).
This Helm repository added as a Fallstar recipe source shows the chart in its store with these choices.
