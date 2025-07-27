# Veeam Kasten

Let's see how to run [Veeam Kasten](https://www.veeam.com/products/cloud/kubernetes-data-protection.html) ([docs](https://docs.kasten.io/latest/index.html)) in a Kubernetes cluster.

⚠ Kasten K10 is not open source and is free for up to 5 nodes

## Configuration

We'll use the [official Helm chart](https://docs.kasten.io/latest/install/other/other/):

```yaml
# https://docs.kasten.io/latest/access/dashboard.html
global:
  persistence:
    storageClass: <storage-class-name>
auth:
  tokenAuth:
    enabled: true
externalGateway:
  create: true
  fqdn:
    type: external-dns
    name: <my-desired.dns.name>
ingress:
 create: true
 class: nginx
 annotations:
   nginx.ingress.kubernetes.io/ssl-redirect: 'true'
 urlPath="/<custom-path>"
prometheus:
  server:
    baseURL: "/<custom-path>/prometheus/"
    prefixURL: "/<custom-path>/prometheus/"
route:
  enabled: true
  host: <A FQDN of your choice with proper DNS entry>
  path: "/<custom-path>"
  tls:
    enabled: true
    termination: <reencrypt/edge/passthrough>
    insecureEdgeTerminationPolicy: <disable/redirect/allow>
```

## Deployment

```bash
# adds Helm chart repository
helm repo add kasten https://charts.kasten.io
helm repo update

# installs
helm upgrade --install kasten kasten/k10 --namespace kasten-io --create-namespace

# checks everything is ok
kubectl get pods --namespace kasten-io --watch

# accesses the dashboard with a port forward (http://127.0.0.1:8080/k10/#/)
kubectl --namespace kasten-io port-forward service/gateway 8080:8000

# uninstalls
helm uninstall kasten -n kasten-io
kubectl delete ns kasten-io
```
