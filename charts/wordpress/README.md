# WordPress

This Helm chart will install [WordPress packaged by Bitnami](https://bitnami.com/stack/wordpress/helm) ([GitHub](https://github.com/bitnami/charts/tree/main/bitnami/wordpress),
[Artifact Hub](https://artifacthub.io/packages/helm/bitnami/wordpress)).

## How to update the chart

```bash
# (only once) adds bitnami helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# updates repository information
helm repo update

# lists available charts
helm search repo wordpress

# updates Chart.yaml with the lastest version available
```

## How to deploy manually

```bash
# installs locally the related charts
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template -f values.yaml \
  --namespace sample-apps . > temp.yaml

# get ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install -f values.yaml --create-namespace \
  --set ingress.enabled=true \
  --set ingress.ingressClassName=nginx \
  --set ingress.selfSigned=true \
  --set ingress.hostname=wordpress.${NGINX_PUBLIC_IP}.sslip.io \
  --namespace sample-apps wordpress .

# looks
kubectl get all -n sample-apps

# if needed, deletes the chart
helm uninstall wordpress -n sample-apps

# open https://wordpress.${NGINX_PUBLIC_IP}.sslip.io/ and https://wordpress.${NGINX_PUBLIC_IP}.sslip.io/wp-login.php
```

## How to get examples

* Use-case: Ingress (NGINX class with self-signed certificate) + WordPress password as secret + Azure storage class

```yaml
secrets:
  wordpressPassword:
    encryptedValue: xxx
wordpress:
  global:
    storageClass: azureblob-fuse
  wordpressUsername: myuser
  wordpressBlogName: "My Wordpress!"
  existingSecret: wordpress-credentials
  ingress:
    enabled: true
    ingressClassName: nginx
    hostname: wordpress.demo
    tls: true
    selfSigned: true
  mariadb:
    auth:
      rootPassword: "xxx"
      password: "xxx"
```

## How to troubleshoot

### MariaDB failing to start

* Check storage class compatibility

### Empty website & incomplete template

* View pod logs
* Increase livenessProbe initialDelaySeconds as WordPress installation may take several minutes (see [Issue #9563](https://github.com/bitnami/charts/issues/9563))

### Error 503

* Make sure Kubernetes `wordpress` service exists (may also be linked to long installation time and disabled probes)
