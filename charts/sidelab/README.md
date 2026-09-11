# Sidelab Helm Chart

Helm chart for Sidelab, a self-hosted interactive lab platform.

In a nutshell:

- Deploys the launcher, which manages lab sessions as ephemeral Kubernetes Pods inside tenant-scoped namespaces
- Supports SQLite (zero-dependency, quick look/demo) or MongoDB as the database backend, and NodePort or Ingress for exposing lab sessions

## Quick Start

1. Add the chart repository

   ```bash
   helm repo add devpro https://devpro.github.io/helm-charts
   helm repo update
   ```

2. Create the `values.yaml` file to override [default values](values.yaml)

   > [!IMPORTANT]
   > One value is always required: `image.repository`.
   >
   > `values.yaml` is the source of truth for every option.
   > It's fully commented, including Traefik/cert-manager/Let's Encrypt examples.
   >
   > `CONTRIBUTING` contains known-good `values.yaml` combinations for every use case.

3. Install the application:

   ```bash
   helm upgrade --install sidelab devpro/sidelab -f values.yaml \
     --namespace sidelab --create-namespace
   ```

## Uninstall

```bash
helm uninstall sidelab -n sidelab
kubectl delete namespace sidelab
```

> [!NOTE]
> The auto-generated `<release>-auth` Secret (admin password) and the data PVC are deleted along with the namespace.
> Back up `database.mongo.url`'s target or the PVC first if data must be kept.

## Going further

Check the [contribution guide](CONTRIBUTING.md) for additional information.
