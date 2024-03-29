# Rancher

This Helm chart will install [Rancher](https://www.rancher.com/) ([docs](https://docs.ranchermanager.rancher.io/), [code](https://github.com/rancher/rancher))
and is based from the [official Helm chart](https://github.com/rancher/rancher/tree/release/v2.7/chart) ([docs]((https://docs.ranchermanager.rancher.io/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster))).

💡 Kubernetes objects will be installed in `cattle-system` namespace

## How to update the chart

```bash
# adds helm chart repository
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update

# searches for the latest version
helm search repo -l rancher

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

* Example with NGINX Ingress controller, cert-manager, Let's Encrypt

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# checks the Kubernetes objects generated from the chart
helm template rancher . -f values.yaml \
  --namespace cattle-system > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install rancher . -f values.yaml --create-namespace \
  --set rancher.hostname=rancher.${NGINX_PUBLIC_IP}.sslip.io \
  --set 'rancher.ingress.extraAnnotations.cert-manager\.io/cluster-issuer=letsencrypt-prod' \
  --set rancher.ingress.ingressClassName=nginx \
  --set rancher.ingress.tls.source=secret \
  --set rancher.ingress.tls.secretName=rancher-tls \
  --namespace cattle-system

# checks everything is ok
kubectl get svc,deploy,pod,ingress,pv,certificate -n cattle-system

# retrieves generated password
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{ .data.bootstrapPassword|base64decode}}{{ "\n" }}'

# manual: open https://rancher.${NGINX_PUBLIC_IP}.sslip.io/ (and login with admin and the password)

# if needed, deletes the chart
helm uninstall rancher -n cattle-system
```

## How to start once the application is running

TODO

## How to investigate

TODO
