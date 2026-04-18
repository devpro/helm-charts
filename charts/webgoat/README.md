# OWASP WebGoat Helm Chart

Helm chart for [WebGoat Web Application](https://owasp.org/www-project-webgoat/) — designed for container security workshops.

## Architecture

- **WebGoat** — main app
- **WebWolf** — companion app for email/webhook exercises

## Quick Start

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the chart:

```bash
helm upgrade --install webgoat devpro/webgoat -f values.yaml --namespace webgoat --create-namespace
```

## Uninstall

```bash
helm uninstall webgoat -n webgoat
kubectl delete namespace webgoat
```

## Going further

Check the [contribution guide](CONTRIBUTING.md).

---
> ⚠️ **FOR WORKSHOP USE ONLY** — intentionally vulnerable, never expose to the internet.
