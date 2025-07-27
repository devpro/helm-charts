# PostgreSQL

Let's see how to run [PostgreSQL](https://www.postgresql.org/) ([code](https://github.com/postgres/postgres)) in a Kubernetes cluster.

## Configuration

We'll use the [Bitnami's Helm chart](https://bitnami.com/stack/postgresql/helm) ([code](https://github.com/bitnami/charts/blob/main/bitnami/postgresql)):

- [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# installs
helm upgrade --install postgresql bitnami/postgresql  --namespace postgresql --create-namespace

# checks everything is ok
kubectl get pod -n postgresql

# uninstalls
helm uninstall reportportal -n reportportal
kubectl delete ns reportportal
```

## Examples

### Minimal installation with default parameters and fixed password

Install the application:

```bash
helm upgrade --install postgresql bitnami/postgresql --namespace postgresql --create-namespace \
  --set postgresql.auth.postgresPassword=secretpassword
```

Forward the service port for local access:

```bash
kubectl port-forward service/postgresql 5432:5432 -n postgresql
```

Use [pgAdmin](https://www.pgadmin.org/) to access the service on [localhost:5432](http://localhost:5432/) and log in with postgres/secretpassword.
