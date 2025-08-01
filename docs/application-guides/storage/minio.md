# MinIO

Let's see how to run [MinIO](https://min.io/) ([code](https://github.com/minio/minio)) in a Kubernetes cluster.

## Repository

We'll use the [the official Helm chart](https://github.com/minio/minio/tree/master/helm/minio):

```bash
helm repo add minio https://charts.min.io/
helm repo update
```

## Configuration

Create the `values.yaml` file to override [default parameters](https://github.com/minio/minio/blob/master/helm/minio/values.yaml).

::: code-group

```yaml [Minimal]
resources:
  requests:
    memory: 512Mi
replicas: 1
mode: standalone
persistence:
  enabled: false
# access key length should be at least 3 character long
rootUser: admin
# secret key length should be at least 8 character long
rootPassword: pasWd8char
```

```yaml [Stateful]
persistence:
  enabled: true
  size: 10Gi
```

```yaml [Ingress]
ingress:
  enabled: true
  ingressClassName: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - minio.somedomain
  tls:
    - secretName: minio-tls
      hosts:
        - minio.somedomain
consoleIngress:
  enabled: true
  ingressClassName: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - minio-console.somedomain
  tls:
    - secretName: minio-console-tls
      hosts:
        - minio-console.somedomain
```

:::

## Deployment

Install the application:

```bash
helm upgrade --install minio minio/minio -f values.yaml --namespace minio --create-namespace
```

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm uninstall minio -n minio
kubectl delete ns minio
```
