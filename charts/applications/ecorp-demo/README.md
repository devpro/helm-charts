# E Corp Helm charts

Helm chart to deploy E Corps applications on a Kubernetes cluster.

## How to check chart

```bash
# lints the chart
helm lint .

# creates Kubernetes template file from chart
helm template . -f values.yaml --set aspnetcore.environment=Development > temp.yaml
```

## How to deploy manually

```bash
# get ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install -f values.yaml --create-namespace \
  --set aspnetcore.environment=Development --set frontend.host=front.${NGINX_PUBLIC_IP}.sslip.io --set backend.host=back.${NGINX_PUBLIC_IP}.sslip.io \
  --set 'ingress.annotations.cert-manager\.io/cluster-issuer=selfsigned-cluster-issuer' \
  --set 'ingress.annotations.nginx\.ingress\.kubernetes\.io/backend-protocol="HTTPS"' \
  --set 'backend.tls.secretName=ecorp-backend-tls' \
  --set 'frontend.tls.secretName=ecorp-frontend-tls' \
  --namespace ecorp ecorp-demo .

# checks everythings is ok
kubectl get all -n ecorp
kubectl get Secrets,Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges -n ecorp

# if needed, deletes the chart
helm delete ecorp-demo -n ecorp
```
