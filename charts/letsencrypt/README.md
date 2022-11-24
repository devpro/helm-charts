# Let's Encrypt

This Helm chart will install [Let's Encrpyt](https://letsencrypt.org/) ([docs](https://letsencrypt.org/docs/)).

💡 Helm chart will be installed in `cert-manager` namespace and must be installed after `cert-manager` chart

## How to deploy manually

```bash
# checks the Kubernetes objects generated from the chart
helm template letsencrypt . -f values.yaml \
  --namespace cert-manager > temp.yaml

# installs the chart with helm
helm upgrade --install letsencrypt . -f values.yaml --create-namespace \
  --set registration.emailAddress=mypersonal@email.address \
  --namespace cert-manager

# checks installation is ok
kubectl get ClusterIssuers -n cert-manager

# if needed, deletes the chart
helm delete letsencrypt -n cert-manager
```

## How to investigate

### Check existing resources

```bash
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```
