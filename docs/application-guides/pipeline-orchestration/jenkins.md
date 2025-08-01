# Jenkins

Let's see how to run [Jenkins](https://www.jenkins.io/) ([code](https://github.com/jenkinsci/jenkins), [docs](https://www.jenkins.io/doc/)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://github.com/jenkinsci/helm-charts/blob/main/charts/jenkins/README.md) ([docs](https://www.jenkins.io/doc/book/installing/kubernetes/#install-jenkins-with-helm-v3)):

- [values.yaml](https://github.com/jenkinsci/helm-charts/blob/main/charts/jenkins/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add jenkinsci https://charts.jenkins.io
helm repo update

# installs
helm upgrade --install jenkins jenkinsci/jenkins --namespace jenkins --create-namespace

# checks everything is ok
kubectl get pod -n jenkins

# uninstalls
helm uninstall jenkins -n jenkins
kubectl delete ns jenkins
```

## Examples

### Kubernetes cluster with NGINX Ingress Controller, sslip.io, cert-manager and Let's Encrypt issuers

Create the `values.yaml` file:

```yaml
controller:
  adminUser: "admin"
  admin:
    existingSecret: ""
    userKey: jenkins-admin-user
    passwordKey: jenkins-admin-password
  resources:
    requests:
      cpu: "300m"
      memory: "512Mi"
    limits:
      cpu: "500m"
      memory: "2048Mi"
```

Install Jenkins:

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs the chart
helm upgrade --install jenkins jenkinsci/jenkins -f values.yaml --namespace jenkins --create-namespace \
  --set controller.ingress.enabled=true \
  --set controller.ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set controller.ingress.ingressClassName=nginx \
  --set controller.ingress.hostName=jenkins.${NGINX_PUBLIC_IP}.sslip.io \
  --set controller.ingress.tls[0].secretName=jenkins-tls \
  --set controller.ingress.tls[0].hosts[0]=jenkins.${NGINX_PUBLIC_IP}.sslip.io

# retrieves the generated password
printf $(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
```

Open the URL and log in with admin and the displayed password.
