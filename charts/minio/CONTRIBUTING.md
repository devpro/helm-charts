# Contribute

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add minio https://charts.min.io/
helm repo update

# searches for the latest version
helm search repo -l minio --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to check the manifest before deployment

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template minio . -f values.yaml \
  --namespace minio > temp.yaml
```

## How to deploy the chart from the sources

```bash
# installs on a cluster
helm upgrade --install minio . -f values.yaml --create-namespace \
  --set minio.resources.requests.memory=512Mi \
  --set minio.replicas=1 --set minio.mode=standalone \
  --set minio.persistence.enabled=false \
  --set minio.rootUser=admin,minio.rootPassword=pasWd8char \
  --namespace minio \
  # --debug
```

## How to access the console

### Example with NGINX Ingress Controller and a default storage class defined

ℹ MinIO Server comes with an embedded web based object browser

```bash
# gets Ingress Controller external IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs on a cluster
helm upgrade --install minio . -f values.yaml --create-namespace \
  --set minio.resources.requests.memory=512Mi \
  --set minio.replicas=1 \
  --set minio.mode=standalone \
  --set minio.persistence.enabled=true,minio.persistence.size=10Gi \
  --set minio.rootUser=admin,minio.rootPassword=pasWd8char \
  --set minio.ingress.enabled=true,minio.ingress.ingressClassName=nginx,minio.ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set minio.ingress.hosts[0]=minio.${NGINX_PUBLIC_IP}.sslip.io \
  --set minio.ingress.tls[0].secretName=minio-tls \
  --set minio.ingress.tls[0].hosts[0]=minio.${NGINX_PUBLIC_IP}.sslip.io \
  --set minio.consoleIngress.enabled=true,minio.consoleIngress.ingressClassName=nginx,minio.consoleIngress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set minio.consoleIngress.hosts[0]=minio-console.${NGINX_PUBLIC_IP}.sslip.io \
  --set minio.consoleIngress.tls[0].secretName=minio-console-tls \
  --set minio.consoleIngress.tls[0].hosts[0]=minio-console.${NGINX_PUBLIC_IP}.sslip.io \
  --namespace minio

# manual: open http://minio-console.${NGINX_PUBLIC_IP}.sslip.io/ (log in with admin/pasWd8char)
```
