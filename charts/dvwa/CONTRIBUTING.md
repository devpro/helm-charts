# Contribution guide

## Validate on a test cluster

Create a `values.mine.yaml` file:

```yaml
ingress:
  enabled: true
  domain: "dvwa.console.$SANDBOX_ID.instruqt.io"
  className: "traefik"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  tls:
    enabled: true

```

Install the chart:

```bash
helm upgrade --install dvwa . -f values.yaml -f values.mine.yaml --namespace dvwa --create-namespace
```

Wait for all pods to be ready:

```bash
kubectl get all -n dvwa
```

Open the web application in a browser.
