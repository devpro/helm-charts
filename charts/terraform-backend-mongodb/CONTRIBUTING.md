# Contribution guide

## Update chart dependencies

Add Bitnami Helm repository:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Look for existing versions:

```bash
helm search repo -l mongodb --versions
```

Manually edit `Chart.yaml` with the version.

Update `Chart.lock`:

```bash
helm dependency update
```
