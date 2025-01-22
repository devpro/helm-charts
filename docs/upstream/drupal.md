# Drupal

## Stable repository

[stable/drupal](https://github.com/helm/charts/tree/master/stable/drupal) refers to [bitnami chart](https://bitnami.com/stack/drupal/helm).

Install with the default values (+ mandatory fields that are required): `helm install d8cluster stable/drupal --set mariadb.rootUser.password=password,mariadb.db.password=secretpassword`.

Wait for the pods to be created: `kubectl get pods`.

You should be able to access your new Drupal installation through [drupal.local](http://drupal.local/) and log with username = "user" and password = `kubectl get secret --namespace default d8cluster-drupal -o jsonpath="{.data.drupal-password}" | base64 --decode`.

If [drupal.local](http://drupal.local/) doesn't work, look at the services state and see if the public ip of the LoadBalancer is defined. If you're on MiniKube it may be undefined, in this case look at minikube services `minikube service d8cluster-drupal --url` and open the link in the URL.

## Additional reading

- Article from Jeff Geerling on [Running Drupal in Kubernetes with Docker in production](https://www.jeffgeerling.com/blog/2019/running-drupal-kubernetes-docker-production) _April 12, 2019_
