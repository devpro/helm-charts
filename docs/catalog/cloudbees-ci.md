# CloudBees CI

Let's see how to run [CloudBees CI](https://docs.cloudbees.com/docs/cloudbees-ci/latest/) ([GitHub](https://github.com/cloudbees)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://docs.cloudbees.com/docs/cloudbees-ci/latest/kubernetes-install-guide/installing-kubernetes-using-helm):

- [values.yaml](https://artifacthub.io/packages/helm/cloudbees/cloudbees-core/#values)

## Deployment

```bash
# adds Helm chart repository
helm repo add cloudbees https://public-charts.artifacts.cloudbees.com/repository/public/
helm repo update

# installs
helm upgrade --install cloudbees-ci cloudbees/cloudbees-core --namespace cloudbees --create-namespace

# checks everything is ok
kubectl get pod -n cloudbees

# uninstalls
helm uninstall cloudbees-ci -n cloudbees
kubectl delete ns cloudbees
```

## Examples

### NGINX, sslip.io, cert-manager & Let's Encrypt

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest
helm upgrade --install cloudbees-ci cloudbees/cloudbees-core --namespace cloudbees --create-namespace \
  --set cloudbees-core.OperationsCenter.HostName=cloudbees-ci.${NGINX_PUBLIC_IP}.sslip.io \
  --set 'cloudbees-core.OperationsCenter.Ingress.Annotations.cert-manager\.io/cluster-issuer=selfsigned-cluster-issuer' \
  --set cloudbees-core.OperationsCenter.Ingress.tls.Enable=true \
  --set cloudbees-core.OperationsCenter.Ingress.tls.SecretName=cloudbees-ci-tls
```
