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
