# Helm chart for PostgreSQL

This Helm chart will install [PostgreSQL](https://www.postgresql.org/) ([code](https://github.com/postgres/postgres)) on a Kubernetes cluster.
It is based on [Bitnami's Helm chart](https://bitnami.com/stack/postgresql/helm) ([code](https://github.com/bitnami/charts/blob/main/bitnami/postgresql)).

## Installation

```bash
# installs the chart with default parameters
helm upgrade --install postgresql devpro/postgresql --create-namespace --namespace postgresql
```

## Getting started

### Minimal installation

```bash
# installs with a fixed password
helm upgrade --install postgresql devpro/postgresql --create-namespace \
  --set postgresql.auth.postgresPassword=secretpassword \
  --namespace postgresql

# forwards service port for local access
kubectl port-forward service/postgresql 5432:5432 -n postgresql

# manual: use pgAdmin (https://www.pgadmin.org/) to access the service on http://localhost:5432/ (log in with postgres/secretpassword)

# cleans up
helm uninstall postgresql -n postgresql
kubectl delete ns postgresql
```
