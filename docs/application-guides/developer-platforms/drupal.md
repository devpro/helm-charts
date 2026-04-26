# Drupal

## Stable repository

[stable/drupal](https://github.com/helm/charts/tree/master/stable/drupal) refers to [bitnami chart](https://bitnami.com/stack/drupal/helm).

Install with the default values (+ mandatory fields that are required):

```bash
helm install d8cluster stable/drupal \
  --set mariadb.rootUser.password=password
  --set mariadb.db.password=secretpassword
```

Wait for the pods to be created:

```bash
kubectl get pods
```

You should be able to access your new Drupal installation through [drupal.local](http://drupal.local/) and log with username "user" and password given by:

```bash
kubectl get secret --namespace default d8cluster-drupal -o jsonpath="{.data.drupal-password}" | base64 --decode
```

If [drupal.local](http://drupal.local/) doesn't work, look at the services state and see if the public ip of the LoadBalancer is defined.
If you're on MiniKube it may be undefined, in this case look at minikube services and open the link in the URL:

```bash
minikube service d8cluster-drupal --url
```

## Additional reading

- Article from Jeff Geerling on [Running Drupal in Kubernetes with Docker in production](https://www.jeffgeerling.com/blog/2019/running-drupal-kubernetes-docker-production) _April 12, 2019_

{/*

[bitnami/charts](https://github.com/bitnami/charts/blob/main/bitnami/drupal/README.md)

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

cat <<EOF > drupal_values.yaml
image:
  registry: docker.io
  repository: drupal
  tag: "8.5"
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
EOF

helm install drupal bitnami/drupal -f drupal_values.yaml --namespace drupal --create-namespace \
  --set ingress.hosts[0].host="drupal.console.${_SANDBOX_ID}.instruqt.io" \
  --set ingress.tls[0].host[0]="drupal.console.${_SANDBOX_ID}.instruqt.io"

echo "https://drupal.console.${_SANDBOX_ID}.instruqt.io"

kubectl get all -n drupal
```

*/}
