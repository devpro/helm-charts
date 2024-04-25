# Helm chart for MongoDB Community

This Helm chart will install the community version of [MongoDB](https://www.mongodb.com/) databases on a Kubernetes cluster.
It is based on the [official charts](https://mongodb.github.io/helm-charts/) ([code](https://github.com/mongodb/helm-charts)).

## Quick start

- Add Helm repositories

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo add mongodb https://mongodb.github.io/helm-charts
helm repo update
```

- Install MongoDB Community Custom Resource Definitions (CRDs)

```bash
helm install community-operator-crds mongodb/community-operator-crds --version "0.9.0" --create-namespace --namespace mongodb
```

- Create a secret with the password for every user

```bash
kubectl create secret generic <secret-name> --from-literal=password='somePassword' --namespace mongodb
```

- Initiate `values_mine.yaml` from [values.yaml](values.yaml) and configure the database(s) to be created

- Install MongoDB Community Operator and create databases

```bash
helm upgrade --install mongodb-community devpro/mongodb-community -f values_mine.yaml --namespace mongodb
```

- Review the databases

```bash
kubectl get mdbc --namespace mongodb
```

- Clean-up

```bash
helm uninstall mongodb-community -n mongodb
kubectl delete ns mongodb
```

## Going further

Look at the [Contributing](CONTRIBUTING.md) page.
