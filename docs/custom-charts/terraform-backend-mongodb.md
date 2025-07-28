# Terraform Backend MongoDB

This Helm chart will deploy [Terraform Backend MongoDB](https://github.com/devpro/terraform-backend-mongodb) on a Kubernetes cluster.

## Usage

Add Helm chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Install the chart:

```bash
helm upgrade --install tfbackend devpro/terraform-backend-mongodb -f values.yaml -namespace tfbackend --create-namespace
```

Uninstall the chart:

```bash
helm delete tfbackend
kubectl delete ns tfbackend
```

## Configuration

### `values.yaml` file

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
