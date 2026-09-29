# Contribute

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add ory https://k8s.ory.sh/helm/charts
helm repo update

# searches for the latest version
helm search repo -l kratos --versions
helm search repo -l postgresql --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to check the manifest code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template kratos . -f values.yaml --namespace kratos \
  --set kratos.kratos.config.dsn=postgres://foo:bar@pg-sqlproxy-gcloud-sqlproxy:5432/db \
  > temp.yaml
```

## How to deploy the chart from the sources

### Example with NGINX Ingress Controller

```bash
# gets Ingress Controller external IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs on a cluster
helm upgrade --install kratos . -f values.yaml --create-namespace \
  --set kratos.kratos.config.dsn=postgres://postgres:secretpassword@kratos-postgresql:5432/kratos \
  --set-file kratos.kratos.identitySchemas.'identity\.default\.schema\.json'=examples/kratos/email-password/identity.schema.json \
  --set kratos.kratos.automigration.enabled=true \
  --set kratos.ingress.admin.enabled=true \
  --set kratos.ingress.admin.className=nginx \
  --set kratos.ingress.admin.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set kratos.ingress.admin.hosts[0].host=kratos-admin.${NGINX_PUBLIC_IP}.sslip.io \
  --set kratos.ingress.admin.tls[0].secretName=kratos-admin-tls \
  --set kratos.ingress.admin.tls[0].hosts[0]=kratos-admin.${NGINX_PUBLIC_IP}.sslip.io \
  --set kratos.ingress.public.enabled=true \
  --set kratos.ingress.public.className=nginx \
  --set kratos.ingress.public.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set kratos.ingress.public.hosts[0].host=kratos.${NGINX_PUBLIC_IP}.sslip.io \
  --set kratos.ingress.public.tls[0].secretName=kratos-tls \
  --set kratos.ingress.public.tls[0].hosts[0]=kratos.${NGINX_PUBLIC_IP}.sslip.io \
  --set postgresql.dependency.enabled=true \
  --set postgresql.global.postgresql.auth.postgresPassword=secretpassword \
  --namespace kratos \
  --debug

# manual: open http://kratos.${NGINX_PUBLIC_IP}.sslip.io/ (log in with admin/pasWd8char)
```
