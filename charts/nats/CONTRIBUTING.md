# Contribute to NATS Helm chart

## How to update the dependencies

```bash
# makes sure the repository has been added and refreshed
helm repo add nats https://nats-io.github.io/k8s/helm/charts
helm repo update

# searches for the latest version
helm search repo -l nats/nats --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy the chart from the sources

```bash
# creates my values files
cat <<EOF | tee values_mine.yaml

EOF

# reviews the generated manifest
helm template . -f values.yaml -f values_mine.yaml --name-template=nats -n nats --debug > temp.yaml

# deploys the chart on a cluster
helm upgrade --install nats . -f values.yaml -f values_mine.yaml --namespace nats

# cleans-up
helm uninstall nats -n nats
kubectl delete ns nats
```
