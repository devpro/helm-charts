# Longhorn

Let's see how to run [Longhorn](https://longhorn.io/) ([docs](https://longhorn.io/docs/), [code](https://github.com/longhorn/longhorn)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://longhorn.io/docs/1.9.0/deploy/install/install-with-helm/) ([code](https://github.com/longhorn/charts)):

- [values.yaml](https://github.com/longhorn/charts/blob/master/charts/longhorn/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add longhorn https://charts.longhorn.io
helm repo update

# installs
helm upgrade --install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace

# checks everything is ok
kubectl get pod -n longhorn-system
kubectl get sc longhorn

# uninstalls
helm uninstall longhorn -n longhorn-system
kubectl delete ns longhorn-system
```

## Examples

### Kubernetes cluster with NGINX Ingress Controller, UI secured by password, cert-manager and Let's Encrypt issuers

Install Longhorn:

```bash
# creates a password for the UI (see https://longhorn.io/docs/1.4.0/deploy/accessing-the-ui/longhorn-ingress/)
USER=<USERNAME_HERE>; PASSWORD=<PASSWORD_HERE>; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
kubectl -n longhorn-system create secret generic basic-auth --from-file=auth

# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs the chart
helm upgrade --install longhorn . -f values.yaml --namespace longhorn-system --create-namespace \
  --set longhorn.ingress.enabled=true \
  --set longhorn.ingress.ingressClassName=nginx \
  --set longhorn.ingress.host=longhorn.${NGINX_PUBLIC_IP}.sslip.io \
  --set longhorn.ingress.tls=true \
  --set 'longhorn.ingress.annotations.cert-manager\.io/cluster-issuer=letsencrypt-prod' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/auth-type=basic' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/ssl-redirect="false"' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/auth-secret=basic-auth' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/auth-realm="Authentication Required "' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/proxy-body-size=10000m'
```

Open Longhorn dashboard (UI), in this case `https://longhorn.${NGINX_PUBLIC_IP}.sslip.io/`.

### MariaDB persistence storage

```bash
# installs MariaDB
helm upgrade --install mariadb bitnami/mariadb --namespace mariadb-system --create-namespace \
  --set global.storageClass=longhorn

# checks the pod (state should be Running)
kubectl get pod -n mariadb-system

# checks the persistent volume and claims (status should be Bound)
kubectl get pvc,pv -n mariadb-system

# cleans-up resources
helm delete mariadb -n mariadb-system
kubectl delete persistentvolumeclaim/data-mariadb-0 -n mariadb-system
```
