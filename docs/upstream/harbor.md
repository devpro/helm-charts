# Harbor

Let's see how to run [Harbor](https://goharbor.io/) ([code](https://github.com/goharbor/harbor)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://github.com/goharbor/harbor-helm) ([docs]((https://goharbor.io/docs/2.6.0/install-config/harbor-ha-helm/))):

- [values.yaml](https://github.com/goharbor/harbor-helm/blob/master/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add harbor https://helm.goharbor.io
helm repo update

# installs
helm upgrade --install harbor harbor/harbor --namespace harbor --create-namespace

# uninstalls
helm uninstall harbor -n harbor
kubectl delete ns harbor
```

## Examples

### Kubernetes cluster with NGINX Ingress Controller, cert-manager and Let's Encrypt issuers

Install the workload:

```bash
cat <<EOF > values.yaml
harbor:
  expose:
    ingress:
      className: "nginx"
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt-prod
        # ingress.kubernetes.io/proxy-body-size: "0"
        # ingress.kubernetes.io/ssl-redirect: "true"
        # nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
        # nginx.ingress.kubernetes.io/proxy-body-size: "0"
        # nginx.ingress.kubernetes.io/ssl-redirect: "true"
    tls:
      certSource: secret
      secret:
        secretName: harbor-tls
        notarySecretName: harbor-notary-tls
EOF

# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs the application
helm upgrade --install harbor harbor/harbor -f values.yaml --namespace harbor --create-namespace
  --set harbor.expose.ingress.hosts.core=harbor.${NGINX_PUBLIC_IP}.sslip.io \
  --set harbor.expose.ingress.hosts.notary=harbor-notary.${NGINX_PUBLIC_IP}.sslip.io \
  --set harbor.externalURL=https://harbor.${NGINX_PUBLIC_IP}.sslip.io
```

Open `https://harbor.${NGINX_PUBLIC_IP}.sslip.io/` and log in with admin/Harbor12345.
