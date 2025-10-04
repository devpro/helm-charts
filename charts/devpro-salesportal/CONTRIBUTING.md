# Contributing guide

## Update chart dependencies

1. Add Bitnami chart repository:

    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update
    ```

2. Search for the latest version:

    ```bash
    helm search repo -l bitnami/mongodb --versions
    ```

3. Edit manually `Chart.yaml` with the new version

4. Update `Chart.lock`:

    ```bash
    helm dependency update
    ```

## Run locally

### ngrok

Deploy on a cluster with ngrok for the ingress and certificate (ngrok operator must be installed with Helm):

```bash
helm upgrade --install sales-portal . -f values.yaml --namespace sales-portal --create-namespace \
  --set mongodb.enabled=true \
  --set mongodb.auth.rootPassword=admin \
  --set data.db.connectionString=mongodb://root:admin@sales-portal-mongodb:27017/sales-portal?authSource=admin \
  --set data.db.databaseName=sales-portal \
  --set ingress.enabled=true \
  --set ingress.className=ngrok \
  --set front.host=sales-portal.devpro.ngrok.dev \
  --set front.tls=null \
  --set adapter.host=crm-adapter.devpro.ngrok.dev \
  --set adapter.tls=null \
  --set data.host=crm-data.devpro.ngrok.dev \
  --set data.tls=null \
  --set dotnet.environment=Development \
  --set dotnet.enableSwagger=true \
  --set dotnet.enableOpenTelemetry=true
```

Check everything is ok:

```bash
kubectl get all -n sales-portal
```

Optionally forwards MongoDB port for local access and open MongoDB compass (`mongodb://localhost:27017/`, `root/admin`):

```bash
kubectl port-forward service/sales-portal-mongodb 27017:27017 -n sales-portal
```

Clean-up:

```bash
helm delete sales-portal -n sales-portal
kubectl delete ns sales-portal
```
