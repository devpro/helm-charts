# Helm chart for Devpro Sales Portal

This Helm chart will install [Devpro Sales Portal](https://github.com/devpro/sales-portal) on a Kubernetes cluster.

## Usage

[Helm](https://helm.sh) must be installed to use the charts. Once correctly setup, add the repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
```

If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages. You can then run `helm search repo sales-portal` to see the charts.

To install the chart:

```bash
helm upgrade --install sales-portal devpro/sales-portal --create-namespace --namespace sales-portal
```

To uninstall the chart and clean-up the cluster:

```bash
helm delete sales-portal
kubectl delete ns sales-portal
```

## Development

### Update chart dependencies

Make sure to run `../../scripts/add_helm_repos.sh` and look at available version with with `helm search repo -l mongodb --versions`.

Every time you update `Chart.yaml`, run `helm dependency update` to update `Chart.lock`.

### Linting

Run `helm lint` to check the chart.

### Reviewing generated chart

Run `helm template sales-portal . -f values.yaml > temp.yaml` to look at what is generated.

## Examples

### Installation with MongoDB

```bash
# installs or updates the Helm release
helm upgrade --install sales-portal-beta . -f values.yaml --create-namespace \
  --set mongodb.enabled=true,mongodb.auth.rootPassword=admin \
  --set data.db.connectionString=mongodb://root:admin@sales-portal-beta-mongodb:27017/sales-portal-beta?authSource=admin \
  --set data.db.databaseName=sales-portal-beta \
  --namespace sales-portal-beta

# (optional) forwards MongoDB port for local access
kubectl port-forward service/sales-portal-beta-mongodb 27017:27017 -n sales-portal-beta

# forwards port for local access
kubectl port-forward service/salesportal-wasmapp-svc 3001:80 -n sales-portal-beta

# accesses with http://localhost:3001/
curl http://localhost:3001/

# cleans up
helm delete sales-portal-beta -n sales-portal-beta
kubectl delete ns sales-portal-beta
```

### Installation with MongoDB, cert-manager, Let's Encrypt & NGINX Ingress Controller

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install sales-portal-beta . -f values.yaml --create-namespace \
  --set mongodb.enabled=true,mongodb.auth.rootPassword=admin \
  --set data.db.connectionString=mongodb://root:admin@sales-portal-beta-mongodb:27017/sales-portal-beta?authSource=admin \
  --set data.db.databaseName=sales-portal-beta \
  --set ingress.enabled=true,ingress.className=nginx,ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set front.host=sales-portal.${NGINX_PUBLIC_IP}.sslip.io,front.tls.secretName=sales-portal-tls \
  --set adapter.host=crm-adapter.${NGINX_PUBLIC_IP}.sslip.io,adapter.tls.secretName=crm-adapter-tls \
  --set data.host=crm-data.${NGINX_PUBLIC_IP}.sslip.io,data.tls.secretName=crm-data-tls \
  --set dotnet.environment=Development \
  --namespace sales-portal-beta
```
