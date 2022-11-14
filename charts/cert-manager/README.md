# cert-manager

This Helm chart will install [cert-manager](https://cert-manager.io/) ([GitHub](https://github.com/cert-manager/cert-manager), [docs](https://cert-manager.io/docs/), [chart](https://github.com/cert-manager/cert-manager/tree/master/deploy/charts/cert-manager)).

💡 Kubernetes objects will be installed in `cert-manager` namespace

## How to update the chart

```bash
# (only once) adds jetstack helm chart repository
helm repo add jetstack https://charts.jetstack.io

# updates repository information
helm repo update

# lists available charts and get latest version of the chart
helm search repo cert-manager

# (if needed) updates Chart.yaml with version

# updates Chart.lock (and downloads locally the charts)
helm dependency update

# refreshes CRD file
wget -O templates/cert-manager.crds.yaml https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.crds.yaml

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml --namespace cert-manager > temp.yaml
```

## How to deploy manually

```bash
# installs the chart with helm
helm upgrade --install -f values.yaml --namespace cert-manager cert-manager .

# checks deployments (the 3 of them should be READY 1/1)
kubectl get deploy -n cert-manager

# if needed, deletes the chart
helm delete cert-manager -n cert-manager
```

## How to investigate

```bash
# checks existings resources
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```
