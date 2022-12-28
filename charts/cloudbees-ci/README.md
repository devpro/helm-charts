# CloudBees CI Helm chart

This Helm chart will install [CloudBees CI](https://docs.cloudbees.com/docs/cloudbees-ci/latest/) ([GitHub](https://github.com/cloudbees))
and is based from the [official Helm chart](https://docs.cloudbees.com/docs/cloudbees-ci/latest/kubernetes-install-guide/installing-kubernetes-using-helm).

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add cloudbees https://public-charts.artifacts.cloudbees.com/repository/public/
helm repo update

# searches for the latest version
helm search repo -l cloudbees

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# checks the Kubernetes objects generated from the chart
helm template cloudbees-ci . -f values.yaml \
  --namespace cloudbees > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install cloudbees-ci . -f values.yaml --create-namespace \
  --set cloudbees-core.OperationsCenter.HostName=cloudbees-ci.${NGINX_PUBLIC_IP}.sslip.io \
  --set 'cloudbees-core.OperationsCenter.Ingress.Annotations.cert-manager\.io/cluster-issuer=selfsigned-cluster-issuer' \
  --set cloudbees-core.OperationsCenter.Ingress.tls.Enable=true \
  --set cloudbees-core.OperationsCenter.Ingress.tls.SecretName=cloudbees-ci-tls \
  --namespace cloudbees

# checks everything is ok
kubectl get pod -n cloudbees

# if needed, deletes the chart
helm uninstall cloudbees-ci -n cloudbees
```

## How to start once the application is running

* Retrieve the generated password (either in pod logs or in /var/jenkins_home/secrets/initialAdminPassword file in the pod system)

TODO

## How to investigate

### Known issues

TODO
