# Terraform Backend MongoDB

This Helm chart will deploy [Terraform Backend MongoDB](https://github.com/devpro/terraform-backend-mongodb) on a Kubernetes cluster.

## Repository

This is a custom chart:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default parameters](https://github.com/devpro/helm-charts/blob/main/charts/terraform-backend-mongodb/values.yaml).

::: code-group

```yaml [Application]
dotnet:
  environment: Development
  enableSwagger: true
  enableOpenTelemetry: false
```

```yaml [Ingress]
webapi:
  host: tfbackend.mydomain
ingress:
  enabled: true
  className: traefik # or nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
```

```yaml [MongoDB (subchart)]
mongodb:
  enabled: true
  auth:
    rootPassword: admin
webapi:
  db:
    connectionString: mongodb://root:admin@tfbackend-mongodb:27017/terraform_backend_beta?authSource=admin
    databaseName: terraform_backend_beta
```

:::

## Deployment

Install the application:

```bash
helm upgrade --install tfbackend devpro/terraform-backend-mongodb -f values.yaml -namespace tfbackend --create-namespace
```

## Optional checks

If enabled, open the Swagger page from the browser (`<url>/swagger`).

Forward MongoDB port for local access:

```bash
kubectl port-forward service/tfbackend-mongodb 27017:27017 -n tfbackend
```

Use MongoDB Compass to look at the database.

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm delete tfbackend -n tfbackend
kubectl delete ns tfbackend
```
