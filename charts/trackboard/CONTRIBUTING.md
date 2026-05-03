# Contribution guide

## Validate on a test cluster

Create the chart configuration file:

```bash
# example with Traefik ingress controller, cert-manager and Let's Encrypt
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

<!--
helm template trackboard . -f values.yaml -f values.mine.yaml \
  --set ingress.domain=trackboard.server.$SANDBOX_ID.instruqt.io \
  --namespace trackboard > temp.yaml
-->

Install the chart:

```bash
helm upgrade --install trackboard . -f values.yaml -f values.mine.yaml \
  --set ingress.domain=trackboard.server.$SANDBOX_ID.instruqt.io \
  --set admin.password=mysecretpassword \
  --namespace trackboard --create-namespace
```

Wait for all pods to be ready:

```bash
kubectl get all -n trackboard
```

Open the web application in a browser.

```bash
echo "https://trackboard.server.${SANDBOX_ID}.instruqt.io"
```
