# s3gw Helm chart

This Helm chart will install [s3gw.io](https://s3gw.io/) ([docs](https://s3gw-docs.readthedocs.io/en/latest/), [code](https://github.com/aquarist-labs/s3gw))
and is based from the [official Helm chart](https://s3gw-docs.readthedocs.io/en/latest/helm-charts/) ([code](https://github.com/aquarist-labs/s3gw-charts).

## How to use

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install s3gw devpro/s3gw --create-namespace \
  --namespace s3gw-system

# watches the installation and checks all pods are running after some time
kubectl get pod -n s3gw-system --watch

# if needed, deletes the chart
helm uninstall s3gw -n s3gw-system
kubectl delete ns s3gw-system
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
helm repo add s3gw https://aquarist-labs.github.io/s3gw-charts

# searches for the latest version
helm search repo -l s3gw

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template s3gw . -f values.yaml \
  --namespace s3gw-system > temp.yaml
```

## How to deploy manually from the sources

### Sample with cert-manager, Traefic & Longhorn

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install s3gw . -f values.yaml --create-namespace \
  --set s3gw.ui.publicDomain=s3gw-ui.${NGINX_PUBLIC_IP}.sslip.io \
  --set s3gw.publicDomain=s3gw.${NGINX_PUBLIC_IP}.sslip.io \
  --set s3gw.storageClass.name=longhorn \
  --set s3gw.tlsIssuer=letsencrypt-prod
  --namespace s3gw-system
```
