# Contribution guide

## Validate on a test cluster

Create the chart configuration file:

```bash
# example for an Instruqt track, with a Traefik ingress controller, with cert-manager and Let's Encrypt
cat > values.mine.yaml << 'EOF'
ingress:
  enabled: true
  className: "traefik"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  tls:
    enabled: true
EOF
```

Install the chart:

```bash
helm upgrade --install nextportal . -f values.yaml -f values.mine.yaml \
  --set ingress.domain=nextportal.console.$SANDBOX_ID.instruqt.io \
  --namespace nextportal --create-namespace
```

Wait for all pods to be ready:

```bash
kubectl get all -n nextportal
```

Open the web application in a browser.

```bash
echo "https://nextportal.console.${SANDBOX_ID}.instruqt.io"
```
