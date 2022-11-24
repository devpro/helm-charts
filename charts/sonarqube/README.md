# SonarQube

This Helm chart will install [SonarQube](https://www.sonarqube.org/) and is based from the [official Helm chart](https://github.com/SonarSource/helm-chart-sonarqube/tree/master/charts/sonarqube)
([docs]((https://docs.sonarqube.org/latest/setup/sonarqube-on-kubernetes/))).

## How to update the chart

```bash
# adds helm chart repository
helm repo add sonarqube https://sonarsource.github.io/helm-chart-sonarqube
helm repo update

# searches for the latest version
helm search repo -l sonarqube

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# checks the Kubernetes objects generated from the chart
helm template sonarqube . -f values.yaml \
  --namespace supply-chain > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install sonarqube . -f values.yaml --create-namespace \
  --set sonarqube.ingress.hosts[0].name=sonarqube.${NGINX_PUBLIC_IP}.sslip.io \
  --set sonarqube.ingress.tls[0].hosts[0]=sonarqube.${NGINX_PUBLIC_IP}.sslip.io \
  --namespace supply-chain

# checks everything is ok
kubectl get ingress -lrelease=sonarqube -n supply-chain

# manual: open https://sonarqube.${NGINX_PUBLIC_IP}.sslip.io/ (and login with admin/admin)

# if needed, deletes the chart
helm uninstall sonarqube -n supply-chain
```

## How to investigate

* checks existings resources

```bash
kubectl get all -n harbor
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges -n harbor
```
