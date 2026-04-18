# Contribution guide

## Validate on a test cluster

Create a `values.mine.yaml` file:

```yaml
```

Install, or update, the chart:

```bash
helm upgrade --install dvwa . -f values.yaml -f values.mine.yaml --namespace dvwa --create-namespace
```

```bash
kubectl get all -n dvwa
```

Open the web application in a browser.

```bash
echo "DVWA URL → http://$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}'):30080"
```
