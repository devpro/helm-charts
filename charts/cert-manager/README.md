# cert-manager

This Helm chart will install [cert-manager](https://cert-manager.io/) ([GitHub](https://github.com/cert-manager/cert-manager), [docs](https://cert-manager.io/docs/))
from the [official Helm chart](https://github.com/cert-manager/cert-manager/tree/master/deploy/charts/cert-manager)).

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
```

## How to deploy manually

```bash
# checks the Kubernetes objects generated from the chart
helm template cert-manager . -f values.yaml --namespace cert-manager > temp.yaml

# applies CRD file (to be done once)
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.crds.yaml

# installs the chart with helm
helm upgrade --install cert-manager . -f values.yaml --namespace cert-manager

# checks deployments (the 3 of them should be READY 1/1)
kubectl get deploy -n cert-manager

# if needed, deletes the chart
helm delete cert-manager -n cert-manager
kubectl delete ns cert-manager
```

## How to investigate

### Check existing resources

```bash
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```

### Know limitations

* CRDs must be applied before the chart (Helm limitation: [Issue #8668](https://github.com/helm/helm/issues/8668))

* Let's Encrypt certificates can't be added to this chart as they require `cert-manager-webhook` to be working, it needs to be done in a second step
