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

## Validate on a test cluster

Create a `values.mine.yaml` file:

```yaml
dotnet:
  environment: Development
  enableSwagger: true
  enableOpenTelemetry: false
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
mongodb:
  enabled: true
  auth:
    rootPassword: admin
webapi:
  db:
    connectionString: mongodb://root:admin@tfbackend-mongodb:27017/tfbackend_beta?authSource=admin
    databaseName: tfbackend_beta
```

Install or update the application:

```bash
helm upgrade --install tfbackend . \
  -f values.yaml -f values.mine.yaml \
  --set webapi.host=tfbckmdb.console.$SANDBOX_ID.instruqt.io \
  --namespace tfbackend --create-namespace
```

Open application Swagger in a browser.

```bash
echo https://tfbckmdb.console.$SANDBOX_ID.instruqt.io/swagger
```

Create admin:

```bash
curl -O https://raw.githubusercontent.com/devpro/terraform-backend-mongodb/refs/heads/main/scripts/tfbeadm && chmod +x tfbeadm
MONGODB_KUBEDEPLOYNAME=deploy/tfbackend-mongodb \
  MONGODB_URI=mongodb://root:admin@localhost:27017/tfbackend_beta?authSource=admin \
  ./tfbeadm create-user admin admin123 dummy
```

You can now authenticate in the browser.

If needed, to debug:

- Forward MongoDB port to view the database from Compass

    ```bash
    kubectl port-forward svc/tfbackend-mongodb -n tfbackend 27017:27017
    ```

- Have a shell in a MongoDB container

  ```bash
  kubectl exec -it deploy/tfbackend-mongodb -- bash
  ```
