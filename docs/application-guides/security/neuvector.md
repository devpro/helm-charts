# NeuVector

Let's see how to run [NeuVector](https://github.com/neuvector/neuvector) in a Kubernetes cluster.

> [!NOTE]
> Kubernetes objects will be installed in `neuvector` namespace

## Repository

We'll use the [official Helm chart](https://neuvector.github.io/neuvector-helm/):

```bash
helm repo add neuvector https://neuvector.github.io/neuvector-helm/
helm repo update
```

## Configuration

Create the `values.yaml` file to override [default parameters](https://github.com/neuvector/neuvector-helm/blob/master/charts/core/values.yaml).

::: code-group

```yaml [Runtime]
# for RKE2
k3s:
  enabled: true
# for AKS
containerd:
  enabled: true
```

```yaml [Replicas]
controller:
  replicas: 2
cve:
  scanner:
    replicas: 2
```

```yaml [Ingress]
manager:
  ingress:
    enabled: true
    host: neuvector.somedomain
    ingressClassName: nginx
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    tls: true
    secretName: neuvector-tls
```

:::

## Deployment

Install the application:

```bash
helm upgrade --install neuvector neuvector/core -f values.yaml --namespace neuvector --create-namespace
```

Watch objects being created:

```bash
kubectl get all -n neuvector
```

## First steps

Open the website in a browser and by default use admin/admin for the initial login (if a connection timeout message is displayed, wait a little and retry).

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm uninstall neuvector -n neuvector
kubectl delete ns neuvector
```
