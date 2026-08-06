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

## Running several launcher replicas

The launcher is stateless — sessions, lab-token replay protection and expiry claims are coordinated through the database, and running lab Pods are reconciled from it on startup — so it scales horizontally once nothing is stored on the Pod itself:

```yaml
replicaCount: 3

database:
  backend: mongo
  mongo:
    url: mongodb://user:pass@mongo:27017/sidelab

persistence:
  enabled: false      # nothing left to persist locally; a ReadWriteOnce PVC would pin the launcher to one Pod

launcher:
  labAccess: ingress  # nodeport lab URLs are built from the answering node's IP

extraEnv:
  - name: TRUST_PROXY
    value: "1"        # the login throttle is per-replica; without this, per-IP throttling sees only the proxy
```

That combination also switches the Deployment from `Recreate` to `RollingUpdate`, so upgrades no longer drop the dashboard, and makes `autoscaling.enabled` usable.
Asking for more than one replica while `database.backend=sqlite` or a non-`ReadWriteMany` PVC is enabled fails at render time with the fix in the message, rather than silently corrupting a database.

## Uninstall

```bash
helm uninstall sidelab -n sidelab
kubectl delete namespace sidelab
```

The auto-generated `<release>-auth` Secret (admin password) and the data PVC are deleted along with the namespace.
Back up `database.mongo.url`'s target or the PVC first if data must be kept.

## Going further

Check the [contribution guide](CONTRIBUTING.md) for MicroK8s validation steps and known-good `values.yaml` combinations for every use case.
