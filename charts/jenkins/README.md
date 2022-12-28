# Jenkins Helm chart

This Helm chart will install [Jenkins](https://www.jenkins.io/) ([code](https://github.com/jenkinsci/jenkins), [docs](https://www.jenkins.io/doc/))
and is based from the [official Helm chart](https://github.com/jenkinsci/helm-charts/blob/main/charts/jenkins/README.md) ([docs](https://www.jenkins.io/doc/book/installing/kubernetes/#install-jenkins-with-helm-v3)).

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add jenkinsci https://charts.jenkins.io
helm repo update

# searches for the latest version
helm search repo -l jenkins

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# checks the Kubernetes objects generated from the chart
helm template jenkins . -f values.yaml \
  --namespace jenkins > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install jenkins . -f values.yaml --create-namespace \
  --set jenkins.controller.ingress.enabled=true \
  --set 'jenkins.controller.ingress.annotations.cert-manager\.io/cluster-issuer=selfsigned-cluster-issuer' \
  --set jenkins.controller.ingress.ingressClassName=nginx \
  --set jenkins.controller.ingress.hostName=jenkins.${NGINX_PUBLIC_IP}.sslip.io \
  --set jenkins.controller.ingress.tls[0].secretName=jenkins-tls \
  --set jenkins.controller.ingress.tls[0].hosts[0]=jenkins.${NGINX_PUBLIC_IP}.sslip.io \
  --namespace jenkins

# checks everything is ok
kubectl get pod -n jenkins

# if needed, deletes the chart
helm uninstall jenkins -n jenkins
```

## How to start once the application is running

* Retrieve the generated password

```bash
printf $(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
```

* Open the URL and log in with admin/"password"

## How to investigate

### Known issues

TODO
