# Concourse

This Helm chart will install [Concourse](https://concourse-ci.org/) ([docs](https://concourse-ci.org/docs.html))
and is based from the [official Helm chart](https://github.com/concourse/concourse-chart).

## Chart

```bash
helm repo add concourse https://concourse-charts.storage.googleapis.com/
helm repo update

# helm template concourse/concourse --namespace my_namespace -f values.yaml > temp.yaml

helm install my-name concourse/concourse --set concourse.web.externalUrl=my-domain.com --set web.ingress.enabled=true --set web.ingress.hosts[0]=my-domain.com --set web.ingress.tls[0].secretName=domain-web-tls --set web.ingress.tls[0].hosts[0]=my-domain.com

# (Error: unable to build kubernetes objects from release manifest: error validating "": error validating data: [unknown object type "nil" in ConfigMap.data.config-rbac.yml, unknown object type "nil" in ConfigMap.data.main-team.yml])
```

## Stable chart (deprecated)

See [helm/chart](https://github.com/helm/charts/tree/master/stable/concourse) ([values.yaml](https://github.com/helm/charts/blob/master/stable/concourse/values.yaml))

This is the old version but it works on AKS (just need to wait for all pods to be green, with attachment to pvc and startup).

```bash
# create or configure the concourse ingress (edit the service name)
kubectl apply -f ingress.yaml

# check the ingress
kubectl get ingress

# check the secret
kubectl get secrets

# wait for the certificate to be ready
kubectl get certificate domain-web-tls

# activate ingress
helm install my-name stable/concourse --set concourse.web.externalUrl=https://my-domain.com/ --set web.ingress.enabled=true --set web.ingress.hosts[0]=my-domain.com --set web.ingress.tls[0].secretName=domain-web-tls --set web.ingress.tls[0].hosts[0]=my-domain.com --set secrets.localUsers="test:mysecretpassword" --set web.resources.requests.cpu="200m" --set web.resources.requests.memory="256Mi"

# wait for the web pod to be ready
kubectl get pods

# login
fly --target localhost login --concourse-url https://my-domain.com/

# uninstall the chart
helm delete my-name

# clean-up the persistant volumes
kubectl delete pvc ...

# delete the auth namespaces
kubectl delete namespace my-name-main
```

## Known issues

https://discuss.concourse-ci.org/t/concourse-installed-by-helm-chart/1819/5
https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#gzip-types
https://github.com/helm/charts/blob/master/stable/nginx-ingress/values.yaml
https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/
