# DVWA Helm Chart

Helm chart for [Damn Vulnerable Web Application](https://github.com/digininja/DVWA) — designed for container security workshops.

## Architecture

Single pod with two containers:

- **DVWA** — the PHP web app (port 80)
- **MariaDB** — sidecar database (port 3306, localhost only)

## Quick Start

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the chart:

```bash
helm upgrade --install dvwa devpro/dvwa -f values.yaml --namespace dvwa --create-namespace
```

### First-time Setup

1. Browse to the URL above
2. Log in: `admin` / `password`
3. Click **Create / Reset Database**
4. Log in again — ready!

## Values

Key                   | Default    | Description
----------------------|------------|-----------------------------------------
`dvwa.adminUsername`  | `admin`    | DVWA login
`dvwa.adminPassword`  | `password` | DVWA password
`dvwa.securityLevel`  | `low`      | `low` / `medium` / `high` / `impossible`
`persistence.enabled` | `false`    | Persist MariaDB data across pod restarts

## Security Level

Change mid-workshop to increase difficulty:

```bash
helm upgrade dvwa ./dvwa -n dvwa --set dvwa.securityLevel=medium
```

## Uninstall

```bash
helm uninstall dvwa -n dvwa
kubectl delete namespace dvwa
```

## Going further

Check the [contribution guide](CONTRIBUTING.md).

---
> ⚠️ **FOR WORKSHOP USE ONLY** — intentionally vulnerable, never expose to the internet.
