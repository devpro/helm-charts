# Contribution guide

## Validate on a test cluster

Create a `values.mine.yaml` file:

```yaml
ingress:
  enabled: true
  className: "traefik"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  tls:
    enabled: true
```

Install the chart:

```bash
helm upgrade --install drupal . -f values.yaml -f values.mine.yaml --namespace drupal --create-namespace \
  --set ingress.domain="drupal.console.$SANDBOX_ID.instruqt.io"
```

Wait for all pods to be ready:

```bash
kubectl get pod,rs,deploy,svc,ingress,certificate -n drupal
```

Open the web application in a browser:

```bash
echo https://drupal.console.$SANDBOX_ID.instruqt.io
```
