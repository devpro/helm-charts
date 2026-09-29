# Helm chart for Keycloak

This Helm chart will install [Keycloack](https://www.keycloak.org/) ([docs](https://www.keycloak.org/documentation), [code](https://github.com/keycloak/keycloak)) in a Kubernetes cluster.
It is based on [Bitnami Helm chart](https://bitnami.com/stack/keycloak/helm) ([code](https://github.com/bitnami/charts/tree/main/bitnami/keycloak)).

## Quick start

- Add Devpro Helm repository (if this is the first the repo is used)

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

- Review the default configuration from [values.yaml](values.yaml)

- Install or update the chart

```bash
helm upgrade --install keycloak devpro/keycloak --namespace keycloak
```

- [Get started with Keycloak on Kubernetes](https://www.keycloak.org/getting-started/getting-started-kube)

- Clean-up

```bash
helm uninstall keycloak -n keycloak
kubectl delete ns keycloak
```

## Known issues

- Creating the secret at the same time as the chart may cause issue, create the secret first

- Rancher is not compatible with Quarkus ([Keycloak 17.0.0](https://www.keycloak.org/2022/02/keycloak-1700-released.html))
  - [Migrating to Quarkus distribution](https://www.keycloak.org/migration/migrating-to-quarkus)
  - [Rancher issue #38625](https://github.com/rancher/rancher/issues/38625) ([Rancher PR #38822](https://github.com/rancher/rancher/pull/38822))

- Use `extraStartupArgs` value to fix the issue with NGINX Ingress Controller (see [Issue #5074](https://github.com/bitnami/charts/issues/5074))

## Going further

Look at the [Contributing](CONTRIBUTING.md) page.
