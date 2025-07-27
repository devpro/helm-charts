# Contribution guide

## Update chart dependencies

Add Bitnami Helm repository:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Look for existing versions:

```bash
helm search repo -l mongodb --versions
```

Manually edit `Chart.yaml` with the version.

Update `Chart.lock`:

```bash
helm dependency update
```

## Check the manifest code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart on a specific case defined in values_mine.yaml
helm template my-app . -f values.yaml --namespace temp > temp.yaml
```

## Deploy the chart from the sources

### Installation with MongoDB & Ingress

```bash
# installs/updates
helm upgrade --install tfbackend . -f values.yaml --namespace farseer --create-namespace \
--set mongodb.enabled=true \
--set mongodb.auth.rootPassword=admin \
--set webapi.host=tfbackend.mydomain \
--set webapi.db.connectionString=mongodb://root:admin@tfbackend-mongodb:27017/terraform_backend_beta?authSource=admin \
--set webapi.db.databaseName=terraform_backend_beta \
--set ingress.enabled=true \
--set ingress.className=traefik \
--set ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
--set dotnet.environment=Development \
--set dotnet.enableSwagger=true \
--set dotnet.enableOpenTelemetry=false

# (optional) forwards MongoDB port for local access
kubectl port-forward service/tfbackend-mongodb 27017:27017 -n farseer

# (manual) open in a browser the URL/swagger

# uninstalls
helm delete tfbackend -n farseer
kubectl delete ns farseer
```
