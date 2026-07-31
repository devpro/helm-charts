# Sidelab Helm Chart

Helm chart for [Sidelab](https://github.com/devpro-training/sidelab) — a self-hosted interactive lab platform.
Deploys the Sidelab launcher, which manages lab sessions as ephemeral Kubernetes Pods inside tenant-scoped namespaces.

Supports SQLite (zero-dependency, quick look/demo) or MongoDB as the database backend, and NodePort or Ingress for exposing lab sessions.
`values.yaml` is the source of truth for every option.
It's fully commented, including Traefik/cert-manager/Let's Encrypt examples.

## Quick Start

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the application:

```bash
helm upgrade --install sidelab devpro/sidelab -f values.yaml --namespace sidelab --create-namespace
```

One value is always required: `image.repository`.
The chart is public but the sidelab images are not published to a public registry.
Everything else has working defaults: SQLite + NodePort + auto-generated secrets, no external dependencies.
See [CONTRIBUTING.md](CONTRIBUTING.md) for ready-to-use `values.mine.yaml` snippets covering the other use cases (MongoDB, Ingress + cert-manager, the bundled MongoDB demo chart).

## Uninstall

```bash
helm uninstall sidelab -n sidelab
kubectl delete namespace sidelab
```

The auto-generated `<release>-auth` Secret (admin password) and the data PVC are deleted along with the namespace.
Back up `database.mongo.url`'s target or the PVC first if data must be kept.

## Going further

Check the [contribution guide](CONTRIBUTING.md) for MicroK8s validation steps and known-good `values.yaml` combinations for every use case.
