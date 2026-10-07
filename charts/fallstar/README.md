# Fallstar Helm Chart

Helm chart for [Fallstar](https://github.com/devpro/fallstar), GitOps made easy.

## Quick Start

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
helm upgrade --install fallstar devpro/fallstar \
  --set image.repository=<registry>/fallstar \
  --namespace fallstar --create-namespace
```

The image is built from the `Dockerfile` of the Fallstar repository.

> **Tip:** Every option is documented in [values.yaml](values.yaml).

## Uninstall

```bash
helm uninstall fallstar -n fallstar
kubectl delete namespace fallstar
```

> **Note:** Deleting the namespace deletes the generated `<release>-auth` Secret and the data volume.
