# Harbor

This Helm chart will install [Harbor](https://goharbor.io/) ([GitHub](https://github.com/goharbor/harbor), [CNCF project](https://www.cncf.io/projects/harbor/))
and is based from the [official Helm chart](https://github.com/goharbor/harbor-helm) ([docs]((https://goharbor.io/docs/2.6.0/install-config/harbor-ha-helm/))).

## How to update the chart

```bash
# adds helm chart repository
helm repo add harbor https://helm.goharbor.io
helm repo update

# searches for the latest version
helm search repo -l harbor

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# checks the Kubernetes objects generated from the chart
helm template harbor . -f values.yaml \
  --namespace supply-chain > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install -f values.yaml --create-namespace \
  --set harbor.expose.ingress.hosts.core=harbor.${NGINX_PUBLIC_IP}.sslip.io \
  --set harbor.expose.ingress.hosts.notary=harbor-notary.${NGINX_PUBLIC_IP}.sslip.io \
  --set harbor.externalURL=https://harbor.${NGINX_PUBLIC_IP}.sslip.io \
  --namespace supply-chain harbor .

# checks everything is ok
kubectl get ingress -lrelease=harbor -n supply-chain

# manual: open https://harbor.${NGINX_PUBLIC_IP}.sslip.io/ (and login with admin/Harbor12345)

# if needed, deletes the chart
helm uninstall supply-chain -n harbor
```

## How to investigate

* checks existings resources

```bash
kubectl get all -n harbor
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges -n harbor
```
