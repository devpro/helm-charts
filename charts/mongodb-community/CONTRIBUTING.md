# Contribute to MongoDB Community Helm chart

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add mongodb https://mongodb.github.io/helm-charts
helm repo update

# searches for the latest version
helm search repo -l mongodb/community-operator --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy the chart from the sources

```bash
# installs the operator
helm install community-operator-crds mongodb/community-operator-crds --namespace mongodb --version "0.9.0" --create-namespace --namespace mongodb

# creates the user(s) secret containing the password value
kubectl create secret generic mongodb-clusteradmin --from-literal=username=clusteradmin --from-literal=password='S!B\*d$zDsb=' --namespace mongodb

# creates my values files
cat <<EOF | tee values_mine.yaml
databases:
  - name: mongodb-demo
    members: 3
    version: "7.0.5"    # https://hub.docker.com/_/mongo/tags
    users:
      - name: clusteradmin
        db: admin
        passwordSecretRef:
          name: mongodb-clusteradmin
          key: password
        # https://www.mongodb.com/docs/manual/reference/built-in-roles/
        roles:
          - name: clusterAdmin
            db: admin
          - name: userAdminAnyDatabase
            db: admin
          - name: dbAdminAnyDatabase
            db: admin
          - name: readWriteAnyDatabase
            db: admin
        scramCredentialsSecretName: mongodb-clusteradmin-scram
EOF

helm upgrade --install mongodb-community . -f values.yaml -f values_mine.yaml

# reviews the generated manifest
helm template . -f values.yaml -f values_mine.yaml --name-template=mongodb-community -n mongodb --debug > temp.yaml

# deploys the chart on a cluster
helm upgrade --install mongodb-community . -f values.yaml -f values_mine.yaml --namespace mongodb

# waits for the pods to be ready
kubectl wait pods -n mongodb -l app=demo-svc --for condition=Ready --timeout=300s

# opens a tunnel to access the service
kubectl port-forward svc/mongodb-demo-svc 27017:27017 -n mongodb

# manual: you can open MongoDB Compass and connect to the database with the connection string "mongodb://clusteradmin:S!B%5C*d%24zDsb%3D@localhost:27017/admin?authSource=admin&directConnection=true"

# cleans-up
helm uninstall mongodb-community -n mongodb
kubectl delete ns mongodb
```
