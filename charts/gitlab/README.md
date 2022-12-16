# GitLab

This Helm chart will install [GitLab](https://about.gitlab.com/) and is based from the [official Helm chart](https://gitlab.com/gitlab-org/charts/gitlab) ([docs](https://docs.gitlab.com/charts/)).

## How to update the chart

```bash
# adds helm chart repository
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# searches for the latest version
helm search repo -l gitlab

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# optional: checks the Kubernetes objects generated from the chart
helm template gitlab . -f values.yaml \
  --namespace supply-chain > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install gitlab . -f values.yaml --create-namespace \
  --set gitlab.global.hosts.domain=${NGINX_PUBLIC_IP}.sslip.io \
  --set gitlab.global.hosts.registry.name=gitlab-registry.${NGINX_PUBLIC_IP}.sslip.io \
  --set gitlab.global.hosts.minio.name=gitlab-minio.${NGINX_PUBLIC_IP}.sslip.io \
  --set gitlab.global.hosts.kas.name=gitlab-kas.${NGINX_PUBLIC_IP}.sslip.io \
  --set gitlab.certmanager-issuer.email=mypersonal@email.address \
  --namespace supply-chain

# checks you can access the website
kubectl get ingress -lrelease=gitlab -n supply-chain

# retrieves generated password
kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' -n supply-chain | base64 --decode ; echo

# manual: open https://gitlab.${NGINX_PUBLIC_IP}.sslip.io/ (and login with "root" username)

# if needed, deletes the chart
helm uninstall gitlab -n supply-chain
```

## How to investigate

* Review [quickstart](https://docs.gitlab.com/charts/quickstart/)

* Read [Configure secrets for the GitLab chart](https://docs.gitlab.com/charts/installation/secrets.html),
[Configure the GitLab chart with an external NGINX Ingress Controller](https://docs.gitlab.com/charts/advanced/external-nginx/)

* Check existings resources

```bash
kubectl get all -n gitlab
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges -n gitlab
```

* Having an external cert-manager et certificate issuer doesn't work with GitLab official chart

* In case of strange issues, look at gitlab-webservice pod, in particular gitlab-workhorse container
