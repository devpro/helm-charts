# Contribution guide

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

## Validate on a test cluster

Create `values.mine.yaml` file:

```yaml
blazorapp:
  host: keeptrack.console.$SANDBOX_ID.instruqt.io

webapi:
  db:
    connectionString: mongodb://root:admin@keeptrack-mongodb:27017/keeptrack_beta?authSource=admin
    databaseName: keeptrack_beta

firebase:
  webApp:
    apiKey: "***"
    projectId: "***"
  serviceAccount: "***"
  serviceAccount:
    type: "service_account"
    project_id: "***"
    private_key_id: "***"
    private_key: "***"
    client_email: "***"
    client_id: "***"
    auth_uri: "***"
    token_uri: "***"
    auth_provider_x509_cert_url: "***"
    client_x509_cert_url: "***"
    universe_domain: "***"

dotnet:
  environment: Development

ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod

mongodb:
  enabled: true
  auth:
    rootPassword: admin
```

Review the manifest:

```bash
helm template keeptrack . -f values.yaml -f values.mine.yaml --namespace keeptrack --debug > temp.yaml
```

Install or update the application:

```bash
helm upgrade --install keeptrack . -f values.yaml -f values.mine.yaml --namespace keeptrack --create-namespace
```

Add `keeptrack.console.$SANDBOX_ID.instruqt.io` in the authorized domains in Firebase > (myproject) > Authentication > Settings.

Open the web application in a browser.
