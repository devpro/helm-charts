# Sealed Secrets

Let's see how to run [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets/) in a Kubernetes cluster.

## CLI

Install `kubeseal` (check the [releases](https://github.com/bitnami-labs/sealed-secrets/releases)):

```bash
wget -c https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.1/kubeseal-0.19.1-linux-amd64.tar.gz -O - | tar -xz
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
rm kubeseal
```

## Configuration

We'll use the [official Helm chart](https://github.com/bitnami-labs/sealed-secrets/tree/main/helm/sealed-secrets):

- [values.yaml](https://github.com/bitnami-labs/sealed-secrets/blob/main/helm/sealed-secrets/values.yaml)

## Deployment

💡 Helm release name must be "sealed-secrets-controller" in order for kubeseal to work by default (or use `kubeseal --controller-name sealed-secrets <args>`) and be installed in `kube-system` namespace

```bash
# adds Helm chart repository
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update

# installs
helm upgrade --install sealed-secrets-controller sealed-secrets/sealed-secrets --namespace kube-system

# checks installation is ok
kubectl get services -o wide sealed-secrets-controller --namespace kube-system
kubectl get deploy sealed-secrets-controller -n kube-system

# uninstalls
helm delete sealed-secrets-controller -n kube-system
```

## Usage

### Generate the sealed secret manifest

Use kubeseal (kubeconfig must be configured to the cluster where sealed secret has been installed):

```bash
kubectl create secret xxx --namespace=yyy --dry-run=client -o yaml | kubeseal -o yaml > sealedsecret.yaml
```

Example:

```bash
kubectl create secret generic wordpress-credentials \
  --from-literal=wordpress-password='xxxxx' \
  --namespace=fleet-sample --dry-run=client -o yaml | kubeseal -o yaml > wordpress-sealedsecret.yaml
```
