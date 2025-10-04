# Sales Portal

Let's see how to deploy [Sales Portal](https://github.com/devpro/sales-portal) on a Kubernetes cluster.

## Repository

Make sure to have the **devpro** Helm repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

## Configuration

Create the `values.yaml` file to override [default parameters](https://github.com/devpro/helm-charts/blob/main/charts/sales-portal/values.yaml).

::: code-group

```yaml [Application settings]
dotnet:
  environment: Development
  enableSwagger: true
  enableOpenTelemetry: true
```

```yaml [MongoDB subchart]
mongodb:
  enabled: true
  auth:
    rootPassword: admin
data:
  db:
    connectionString: mongodb://root:admin@sales-portal-mongodb:27017/sales-portal?authSource=admin
    databaseName: sales-portal
```

```yaml [NGINX Ingress & cert-manager]
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
front:
  host: sales-portal.my.domain
adapter:
  host: crm-adapter.my.domain
data:
  host: crm-data.my.domain
```

:::

## Deployment

Install the application:

```bash
helm upgrade --install sales-portal devpro/sales-portal -f values.yaml -namespace sales-portal --create-namespace
```

## Optional checks

If enabled, open the Swagger page from the browser (`<url>/swagger`).

Forward MongoDB port for local access:

```bash
kubectl port-forward service/sales-portal-mongodb 27017:27017 -n sales-portal
```

Use MongoDB Compass to look at the database.

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm delete sales-portal -n sales-portal
kubectl delete ns sales-portal
```
