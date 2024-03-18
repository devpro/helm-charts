# Contribute to MongoDB Bitnami Helm chart

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# searches for the latest version
helm search repo -l bitnami/mongodb --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy the chart from the sources

```bash
# creates my values files
cat <<EOF | tee values_mine.yaml
mongodb:
  architecture: standalone
  useStatefulSet: false
  auth:
    rootPassword: admin
  replicaCount: 1
  updateStrategy:
    type: Recreate
EOF

# reviews the generated manifest
helm template . -f values.yaml -f values_mine.yaml --name-template=mongodb-bitnami -n mongodb --debug > temp.yaml

# creates namespace
kubectl create ns mongodb

# deploys the chart on a cluster
helm upgrade --install mongodb-bitnami . -f values.yaml -f values_mine.yaml --namespace mongodb

# waits for the pods to be ready
kubectl wait pods -n mongodb -l app.kubernetes.io/instance=mongodb-bitnami --for condition=Ready --timeout=300s

# opens a tunnel to access the service
kubectl port-forward svc/mongodb-bitnami 27017:27017 -n mongodb

# manual: you can open MongoDB Compass and connect to the database with the connection string "mongodb://root:admin@localhost:27017/admin?authSource=admin&directConnection=true"

# cleans-up
helm uninstall mongodb-bitnami -n mongodb
kubectl delete ns mongodb
```
