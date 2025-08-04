# SonarQube

Let's see how to run [SonarQube](https://www.sonarqube.org/) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://github.com/SonarSource/helm-chart-sonarqube/tree/master/charts/sonarqube) ([docs](https://docs.sonarqube.org/latest/setup/sonarqube-on-kubernetes/)):

- [values.yaml](https://github.com/SonarSource/helm-chart-sonarqube/blob/master/charts/sonarqube/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add sonarqube https://sonarsource.github.io/helm-chart-sonarqube
helm repo update

# installs
helm upgrade --install sonarqube sonarqube/sonarqube --namespace sonarqube --create-namespace

# checks everything is ok
kubectl get pod -n sonarqube

# uninstalls
helm uninstall sonarqube -n sonarqube
kubectl delete ns sonarqube
```

## Examples

### NGINX, sslip.io, cert-manager, Let's Encrypt

Create a values.yaml file:

```yaml
ingress:
  enabled: true
  ingressClassName: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  tls:
    - secretName: sonarqube-tls
```

Install the Helm chart:

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs the application
helm upgrade --install sonarqube sonarqube/sonarqube -f values.yaml --namespace sonarqube --create-namespace \
  --set sonarqube.ingress.hosts[0].name=sonarqube.${NGINX_PUBLIC_IP}.sslip.io \
  --set sonarqube.ingress.tls[0].hosts[0]=sonarqube.${NGINX_PUBLIC_IP}.sslip.io

# checks everything is ok
kubectl get ingress -lrelease=sonarqube -n supply-chain
```

Open in a browser [sonarqube.${NGINX_PUBLIC_IP}.sslip.io](https://sonarqube.${NGINX_PUBLIC_IP}.sslip.io/) and log in with admin/admin.

In "My Account" > "Security" > "Tokens", Generate Global Analysis Token.
