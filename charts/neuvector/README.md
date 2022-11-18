# NeuVector

This Helm chart will install [NeuVector](https://github.com/neuvector/neuvector) ([GitHub](https://github.com/neuvector/neuvector-helm)).

💡 Kubernetes objects will be installed in `neuvector` namespace

## How to update the chart

```bash
# (only once) adds official chart repository
helm repo add neuvector https://neuvector.github.io/neuvector-helm/

# updates repository information
helm repo update

# lists available charts
helm search repo neuvector

# updates Chart.yaml with the lastest version available
```

## How to deploy manually

```bash
# installs locally the related charts
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml --namespace neuvector > temp.yaml

# get ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs the chart with helm
helm upgrade --install --create-namespace \
  --set core.manager.ingress.host=neuvector.${NGINX_PUBLIC_IP}.sslip.io \
  -f values.yaml --namespace neuvector neuvector .

# watchs objects being created
kubectl get all -n neuvector

# open https://neuvector.40.115.47.172.sslip.io/ and do first login with login/login (if connection timeout, wait a little and retry)

# if needed, deletes the chart
helm uninstall neuvector -n neuvector
```

## How to get examples

* Use-case: RKE2 running in Azure VMs

```yaml
core:
  k3s:
    enabled: true
  controller:
    replicas: 2
  cve:
    scanner:
      replicas: 2
  manager:
    ingress:
      enabled: true
      host: xxxx
      ingressClassName: nginx
      annotations:
        cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
      tls: true
      secretName: neuvector-tls-secret
```
