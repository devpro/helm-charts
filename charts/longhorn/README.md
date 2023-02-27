# Longhorn Helm chart

This Helm chart will install [Longhorn](https://longhorn.io/) ([docs](https://longhorn.io/docs/), [code](https://github.com/longhorn/longhorn))
and is based from the [official Helm chart](https://longhorn.io/docs/1.4.0/deploy/install/install-with-helm/) ([code](https://github.com/longhorn/charts)).

Know more about Longhorn: [devpro.github.io](https://devpro.github.io/rancher-ecosystem/docs/longhorn.html)

## How to use

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install longhorn devpro/longhorn --create-namespace \
  --namespace longhorn-system

# watches the installation and checks all pods are running after some time
kubectl get pod -n longhorn-system --watch

# checks the storage class
kubectl get sc longhorn

# if needed, deletes the chart
helm uninstall longhorn -n longhorn-system
kubectl delete ns longhorn-system
```

## How to start once the application is running

- Open Longhorn dashboard (UI), for example "https://longhorn.${NGINX_PUBLIC_IP}.sslip.io/"

- Use Longhorn for example as storage for MariaDB (using [devpro/helm-charts](https://github.com/devpro/helm-charts/blob/main/charts/mariadb/README.md))

```bash
# installs MariaDB
helm upgrade --install mariadb devpro/mariadb --create-namespace \
  --set mariadb.global.storageClass=longhorn \
  --namespace mariadb-system

# checks the pod (state should be Running)
kubectl get pod -n mariadb-system

# checks the persistent volume and claims (status should be Bound)
kubectl get pvc,pv -n mariadb-system

# cleans-up resources
helm delete mariadb -n mariadb-system
kubectl delete persistentvolumeclaim/data-mariadb-0 -n mariadb-system
```

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add longhorn https://charts.longhorn.io

# searches for the latest version
helm search repo -l longhorn

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template longhorn . -f values.yaml \
  --namespace longhorn-system > temp.yaml
```

## How to deploy manually from the sources

### Sample with NGINX Ingress Controller and UI secured by password

```bash
# secure the access to the UI (see https://longhorn.io/docs/1.4.0/deploy/accessing-the-ui/longhorn-ingress/)
USER=<USERNAME_HERE>; PASSWORD=<PASSWORD_HERE>; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
kubectl -n longhorn-system create secret generic basic-auth --from-file=auth

# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install longhorn . -f values.yaml --create-namespace \
  --set longhorn.ingress.enabled=true \
  --set longhorn.ingress.ingressClassName=nginx \
  --set longhorn.ingress.host=longhorn.${NGINX_PUBLIC_IP}.sslip.io \
  --set longhorn.ingress.tls=true \
  --set 'longhorn.ingress.annotations.cert-manager\.io/cluster-issuer=letsencrypt-prod' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/auth-type=basic' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/ssl-redirect="false"' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/auth-secret=basic-auth' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/auth-realm="Authentication Required "' \
  --set 'longhorn.ingress.annotations.nginx\.ingress\.kubernetes\.io/proxy-body-size=10000m' \
  --namespace longhorn-system
```
