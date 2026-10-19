# Fallstar Helm Chart

Helm chart for [Fallstar](https://github.com/devpro/fallstar), GitOps made easy.

## Quick Start

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
helm upgrade --install fallstar devpro/fallstar \
  --set image.repository=<registry>/fallstar \
  --set image.tag=<tag> \
  --namespace fallstar --create-namespace
```

The image is built from the `Dockerfile` of the Fallstar repository.
`ghcr.io/devpro/fallstar` is private, so its pull needs a Secret of type `kubernetes.io/dockerconfigjson` holding a token with `read:packages`, named in `imagePullSecrets`.

> **Tip:** Every option is documented in [values.yaml](values.yaml).

## Uninstall

```bash
helm uninstall fallstar -n fallstar
kubectl delete namespace fallstar
```

> **Note:** Deleting the namespace deletes the generated `<release>-auth` Secret and the data volume.

## Fallstar

`fallstar.yaml` describes the choices of a deployment (database, secrets, image pull, TLS) and the values each one implies, for [Fallstar](https://github.com/devpro/fallstar) itself.
This Helm repository added as a Fallstar recipe source shows the chart in its store with these choices.
