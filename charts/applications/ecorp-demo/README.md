# E Corp Helm charts

Helm chart to deploy E Corps applications on a Kubernetes cluster.

## How to deploy manually

```bash
# creates Kubernetes template file from chart
helm template . -f values.yaml --set aspnetcore.environment=Development > temp.yaml

# applies the manifest
kubectl apply -f temp.yaml -n <namespace_name>
```
