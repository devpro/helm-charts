# E Corp Helm charts

Helm chart to deploy E Corps applications on a Kubernetes cluster, with a [front-end](https://github.com/devpro/ecorp-frontend-demo) and a [back-end](https://github.com/devpro/ecorp-backend-demo) application.

## How to check chart

```bash
# lints the chart
helm lint .
```

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# creates Kubernetes template file from chart
helm template ecorp-demo . -f values.yaml \
  --namespace ecorp > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install -f values.yaml --create-namespace \
  --set aspnetcore.environment=Development \
  --set backend.host=ecorp-demo-api.${NGINX_PUBLIC_IP}.sslip.io \
  --set backend.tls.secretName=ecorp-backend-tls \
  --set frontend.host=ecorp-demo.${NGINX_PUBLIC_IP}.sslip.io \
  --set frontend.tls.secretName=ecorp-frontend-tls \
  --set nodejsApi.host=ecorp-nodejs-api.${NGINX_PUBLIC_IP}.sslip.io \
  --set nodejsApi.tls.secretName=ecorp-nodejs-api-tls \
  --set nodejsApi.env[1].name=RABBITMQ_URL \
  --set nodejsApi.env[1].value="amqp://<username>:<password>@rabbitmq.rabbitmq.svc.cluster.local:5672" \
  --set 'ingress.annotations.cert-manager\.io/cluster-issuer=letsencrypt-prod' \
  --namespace ecorp ecorp-demo .

# checks everythings is ok
kubectl get all -n ecorp
kubectl get Secrets,Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges -n ecorp

# manual: open in a browser https://ecorp-demo.${NGINX_PUBLIC_IP}.sslip.io and https://ecorp-demo-api.${NGINX_PUBLIC_IP}.sslip.io/swagger

# if needed, deletes the chart
helm delete ecorp-demo -n ecorp
```

## Examples

### Legacy only

Create the configuration file:

```bash
cat <<EOF > values_legacy.yaml
frontend:
  enabled: false
backend:
  enabled: false
nodejsApi:
  enabled: false
legacy:
  enabled: true
  host: ecorp-legacy.${NGINX_PUBLIC_IP}.sslip.io
  tls:
    secretName: ecorp-legacy-tls
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
EOF
```

Create the cluster:

```bash
helm upgrade --install ecorp-demo . -f values.yaml -f values_legacy.yaml --namespace ecorp --create-namespace
```

Troubleshooting:

```bash
kubectl exec -it ecorp-legacy-xxx-xxx -n ecorp -- curl http://10.42.xx.xx:80
kubectl delete pod ecorp-legacy-xxx-xxx -n ecorp --grace-period=0 --force
```
