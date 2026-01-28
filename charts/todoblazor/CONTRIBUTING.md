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

## Review the generated manifest

```bash
helm template todoblazor . -f values.yaml -f values.mine.yaml --namespace demo > temp.yaml
```

## Validate on a test cluster

Create the secret with the connection string:

```bash
kubectl create ns demo
kubectl create secret generic todoblazor-database \
  --from-literal=connectionstring='mongodb://root:admin@todoblazor-mongodb:27017/todolist?authSource=admin' \
  --namespace demo
```

Create a `values.mine.yaml` file:

```yaml
dotnet:
  environment: Development
webapp:
  tag: 1.0.21375563304
  db:
    # connectionString: mongodb://root:admin@todoblazor-mongodb:27017/todolist?authSource=admin
    connectionStringSecretKeyRef:
      name: todoblazor-database
      key: connectionstring
    databaseName: todolist
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

Install or update the application:

```bash
helm upgrade --install todoblazor . \
  -f values.yaml -f values.mine.yaml \
  --set webapp.host=todoblazor.console.$SANDBOX_ID.instruqt.io \
  --namespace demo
```

Check everything is ok in the namespace:

```bash
kubectl get pod,svc,deploy,rs,ingress,secret,pvc -n demo
```

Open the web application in a browser:

```bash
echo https://todoblazor.console.$SANDBOX_ID.instruqt.io
```

If needed, debug with:

- Forward MongoDB port to view the database from Compass (with connection string "mongodb://root:admin@localhost:27017/todolist?authSource=admin")

  ```bash
  kubectl port-forward svc/todoblazor-mongodb -n demo 27017:27017
  ```

- Have a shell in a MongoDB container

  ```bash
  kubectl exec -it deploy/todoblazor-mongodb -n demo -- bash
  ```

At the end, clean everything:

```bash
helm delete todoblazor -n demo
kubectl delete ns demo
```
