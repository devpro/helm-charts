# Longhorn

Let's see how to run [Longhorn](https://longhorn.io/) in a Kubernetes cluster with the [official Helm chart](https://longhorn.io/docs/deploy/install/install-with-helm/).

📝 [DevPro note](https://tech.devpro.fr/organizations/companies/suse/longhorn/)

## Repository

First, we add the [Helm repository](https://github.com/longhorn/charts):

```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
```

## Configuration

Create the `values.yaml` file to override [default parameters.yaml](https://github.com/longhorn/charts/blob/master/charts/longhorn/values.yaml).

::: code-group

```yaml [Default]
# persistence:
#   defaultClass: true
# longhornUI:
#   replicas: 2
```

```yaml [Ingress]
ingress:
  enabled: true
  ingressClassName: nginx
  host: longhorn.mydomain.io
  tls: true
  tlsSecret: longhorn-tls
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required "
    nginx.ingress.kubernetes.io/proxy-body-size: 10000m
```

:::

## Authentication

🌐 [Create an Ingress with Basic Authentication (nginx)](https://longhorn.io/docs/deploy/accessing-the-ui/longhorn-ingress/)

Create a password for the UI:

```bash
USER=<USERNAME_HERE>; PASSWORD=<PASSWORD_HERE>; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
kubectl -n longhorn-system create secret generic basic-auth --from-file=auth
```

## Deployment

Install the application:

```bash
helm upgrade --install longhorn longhorn/longhorn -f values.yaml --namespace longhorn-system --create-namespace
```

Watch objects being created:

```bash
kubectl get pod -n longhorn-system
kubectl get sc longhorn
```

> [!TIP]
> A new storage class has been created (default class by default) with the name `longhorn`

If ingress has been set, you can access Longhorn dashboard (web UI).

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm uninstall longhorn -n longhorn-system
kubectl delete ns longhorn-system
```
