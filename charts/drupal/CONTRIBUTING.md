# Contribution guide

## Validate on a test cluster

Create a `values.mine.yaml` file:

```yaml
image: drupal
tag: 8.9.20

ingress:
  enabled: true
  className: "traefik"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  tls:
    enabled: true

persistence:
  enabled: true
  initImage: ghcr.io/devpro/drupal:8.5.0-postinstall
  dbType: sqlite
```

Install the chart:

```bash
helm upgrade --install drupal . -f values.yaml -f values.mine.yaml \
  --set ingress.domain="drupal.server.$SANDBOX_ID.instruqt.io" \
  --namespace drupal --create-namespace
```

Wait for all pods to be ready:

```bash
kubectl get pod,rs,deploy,svc,ingress,certificate,pvc,pv -n drupal
```

Check init container logs:

```bash
kubectl logs -n drupal -l app=drupal -c init-sites
```

Open the web application in a browser:

```bash
echo https://drupal.server.$SANDBOX_ID.instruqt.io
```

Cleanup:

```bash
helm uninstall drupal -n drupal
kubectl get pv --watch
kubectl delete namespace drupal
kubectl get pv | grep drupal
```

<!--
on the server if local-path storage class is used
ls /var/lib/rancher/k3s/storage/
!-->
