# Contribution guide

## Validate on a test cluster

Create a `values.mine.yaml` file:

```yaml
ingress:
  enabled: true
  domain: "console.$SANDBOX_ID.instruqt.io"
  className: "traefik"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  tls:
    enabled: true

```

Install the chart:

```bash
helm upgrade --install webgoat . -f values.yaml -f values.mine.yaml --namespace webgoat --create-namespace
```

Wait for all pods to be ready:

```bash
kubectl get all -n webgoat
```

Open the web application in a browser.

<!--
https://webgoat.console.xxxx.instruqt.io/WebGoat
https://webwolf.console.xxxx.instruqt.io/WebWolf
-->
