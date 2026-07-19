# Helm chart for Terraform Backend MongoDB

This Helm chart will deploy [Terraform Backend MongoDB](https://github.com/devpro/terraform-backend-mongodb) on a Kubernetes cluster.

## Getting started

Start with the [documentation](https://kwt.devpro.fr/custom-charts/terraform-backend-mongodb.html).

## Usage

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the application:

```bash
helm upgrade --install tfbackend devpro/terraform-backend-mongodb -f values.yaml --namespace tfbackend --create-namespace
```

## Database connection

`DatabaseSettings__ConnectionString` is sourced from a Secret via `secretKeyRef` only when you point
the chart at one yourself; otherwise it's rendered as a plain environment variable. Pick one of the
three ways below to provide it; they're evaluated in this priority order:
`webapi.db.connectionStringSecretKeyRef` > `webapi.db.connectionString` > the bundled `mongodb`
subchart.

### Option 1 - your own MongoDB, connection string in a pre-created Secret (recommended for Production)

Create the Secret yourself (`kubectl create secret`, External Secrets Operator, Sealed Secrets, or
your GitOps tool's secret management) with a key holding the full connection string, then point the
chart at it. The chart neither reads nor creates a Secret of its own in this case - the plaintext
value never appears in your values files or in Helm's release history:

```bash
kubectl create secret generic tfbackend-db \
  --namespace tfbackend \
  --from-literal=connectionString='mongodb+srv://user:pass@cluster.mongodb.net'
```

```yaml
webapi:
  db:
    databaseName: "tfbackend"
    connectionStringSecretKeyRef:
      name: tfbackend-db
      key: connectionString
```

### Option 2 - your own MongoDB, connection string as a chart value

Point `webapi.db.connectionString` at a reachable, already-provisioned instance. The chart renders it
directly as a plain env var - the plaintext value is visible in your values file, in `helm get
values`/Helm's release history, and in the Pod spec, so prefer Option 1 for Production credentials:

```yaml
webapi:
  db:
    connectionString: "mongodb+srv://user:pass@cluster.mongodb.net"
    databaseName: "tfbackend"
```

### Option 3 - bundled MongoDB (auto-wired, good for demos/testing)

Enable the bundled `mongodb` subchart and set its root password; the chart derives the connection
string for you and renders it the same way as Option 2 (plain env var). Leave
`webapi.db.connectionString`/`connectionStringSecretKeyRef` empty:

```yaml
mongodb:
  enabled: true
  auth:
    rootPassword: "changeme"
```

Not recommended for anything you care about keeping - it's just another Pod with a PVC, not a
managed/backed-up database.

If none of the three is configured, or `mongodb.enabled=true` is set without `mongodb.auth.rootPassword`,
the chart fails at render/install time with a clear error instead of deploying a Pod that can't reach
a database.

## Going further

Check the [contribution guide](CONTRIBUTING.md).
