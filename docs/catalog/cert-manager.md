# cert-manager

Let's see how to run [cert-manager](https://cert-manager.io/) ([GitHub](https://github.com/cert-manager/cert-manager), [docs](https://cert-manager.io/docs/)) in a Kubernetes cluster.

💡 Kubernetes objects should be installed in `cert-manager` namespace

## Configuration

We'll use the [official Helm chart](https://github.com/cert-manager/cert-manager/tree/master/deploy/charts/cert-manager)):

- [values.yaml](https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml)

## Deployment

Define the version to be used (looking at [releases](https://github.com/cert-manager/cert-manager/releases)):

```bash
CERTMANAGER_VERSION=v1.18.2
```

Create the Custom Resource Definitions (CRD) (must be applied before given the Helm limitation documented in [Issue #8668](https://github.com/helm/helm/issues/8668)):

```bash
kubectl apply -f "https://github.com/cert-manager/cert-manager/releases/download/${CERTMANAGER_VERSION}/cert-manager.crds.yaml"
```

Manage the application:

```bash
# adds Helm chart repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# installs
helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace \
  --version $CERTMANAGER_VERSION

# checks everything is ok (the 3 of them should be READY 1/1)
kubectl get deploy -n cert-manager

# uninstalls
helm delete cert-manager -n cert-manager
kubectl delete ns cert-manager
```
