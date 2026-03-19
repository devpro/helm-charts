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

Create the namespace and secrets:

```bash
kubectl create ns demo
kubectl create secret generic keeptrack-mongodb \
  --from-literal=mongodb-root-password='admin' \
  --namespace demo
kubectl create secret generic keeptrack-app \
  --from-literal=connectionstring='mongodb://root:admin@keeptrack-mongodb:27017/keeptrack?authSource=admin' \
  --from-literal=firebaseapikey='***' \
  --from-literal=firebaseauthdomain='***' \
  --from-literal=firebaseprojectid='***' \
  --from-literal=firebaseauthority='***' \
  --from-file=firebaseserviceaccount=./firebase-service-account.json \
  --namespace demo
```

Create a `values.mine.yaml` file:

```yaml
blazorapp:
  host: keeptrack.console.$SANDBOX_ID.instruqt.io

webapi:
  db:
    connectionStringSecretKeyRef:
      name: keeptrack-app
      key: connectionstring

firebase:
  auth:
    authoritySecretKeyRef:
      name: keeptrack-app
      key: firebaseauthority
  webApp:
    apiKeySecretKeyRef:
      name: keeptrack-app
      key: firebaseapikey
    authDomainSecretKeyRef:
      name: keeptrack-app
      key: firebaseauthdomain
    projectIdSecretKeyRef:
      name: keeptrack-app
      key: firebaseprojectid
  serviceAccountSecretKeyRef:
    name: keeptrack-app
    key: firebaseserviceaccount

ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod

mongodb:
  enabled: true
  auth:
    existingSecret: keeptrack-mongodb
```

Review the manifest:

```bash
helm template keeptrack . -f values.yaml -f values.mine.yaml --namespace demo --debug > temp.yaml
```

Install or update the application:

```bash
helm upgrade --install keeptrack . -f values.yaml -f values.mine.yaml --namespace demo --create-namespace
```

Check everything is ok:

```bash
kubectl get all -n keeptrack
```

Add `keeptrack.console.$SANDBOX_ID.instruqt.io` in the authorized domains in Firebase > (myproject) > Authentication > Settings.

Open the web application in a browser.

At the end, clean everything:

```bash
helm delete keeptrack -n demo
kubectl delete ns demo
```
