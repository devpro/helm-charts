# Helm chart for Let's Encrypt certificate issuers

This Helm chart will install certificate issuers using [Let's Encrpyt](https://letsencrypt.org/) ([docs](https://letsencrypt.org/docs/)).

💡 The certificates require `cert-manager` to be installed on the Kubernetes cluster

## Usage

```bash
# adds devpro Helm repository (if not already done)
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update

# installs the chart with default parameters
helm upgrade --install letsencrypt devpro/letsencrypt --namespace cert-manager \
  --set registration.emailAddress=mypersonal@email.address
  --set ingress.className=traefik

# checks installation is ok
kubectl get ClusterIssuers -n cert-manager

# cleans up
helm uninstall letsencrypt -n cert-manager
```

## Troubleshooting

### Certificate not created

Look at the objects:

```bash
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```
