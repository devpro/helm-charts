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

## Examples

### Installation with MongoDB

```bash
# installs or updates the Helm release
helm upgrade --install sales-portal . -f values.yaml --create-namespace \
  --set mongodb.enabled=true \
  --set mongodb.auth.rootPassword=admin \
  --set data.db.connectionString=mongodb://root:admin@sales-portal-mongodb:27017/sales-portal?authSource=admin \
  --set data.db.databaseName=sales-portal \
  --namespace sales-portal

# (optional) forwards MongoDB port for local access
kubectl port-forward service/sales-portal-mongodb 27017:27017 -n sales-portal

# forwards port for local access
kubectl port-forward service/salesportal-wasmapp-svc 3001:80 -n sales-portal

# accesses with http://localhost:3001/
curl http://localhost:3001/

# cleans up
helm delete sales-portal -n sales-portal
kubectl delete ns sales-portal
```

### Installation with MongoDB, cert-manager, Let's Encrypt & NGINX Ingress Controller

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install sales-portal-beta . -f values.yaml --namespace sales-portal-beta --create-namespace \
  --set mongodb.enabled=true \
  --set mongodb.auth.rootPassword=admin \
  --set data.db.connectionString=mongodb://root:admin@sales-portal-beta-mongodb:27017/sales-portal-beta?authSource=admin \
  --set data.db.databaseName=sales-portal-beta \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set front.host=sales-portal.${NGINX_PUBLIC_IP}.sslip.io \
  --set front.tls.secretName=sales-portal-tls \
  --set adapter.host=crm-adapter.${NGINX_PUBLIC_IP}.sslip.io \
  --set adapter.tls.secretName=crm-adapter-tls \
  --set data.host=crm-data.${NGINX_PUBLIC_IP}.sslip.io \
  --set data.tls.secretName=crm-data-tls \
  --set dotnet.environment=Development \
  --set dotnet.enableSwagger=true \
  --set dotnet.enableOpenTelemetry=true
```
