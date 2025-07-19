# Concourse

Let's see how to run [Concourse](https://concourse-ci.org/) ([docs](https://concourse-ci.org/docs.html)) in a Kubernetes cluster.

## CLI

We'll need Concourse CLI (`fly`) to interact with Concourse server:

```bash
# gets the binary archive from https://github.com/concourse/concourse/releases (update the version)
curl -L https://github.com/concourse/concourse/releases/download/v7.13.2/fly-7.13.2-linux-amd64.tgz | tar -xzf -
sudo mv fly /usr/local/bin/
sudo chmod +x /usr/local/bin/fly
fly --version
```

## Configuration

We'll use the [official Helm chart](https://github.com/concourse/concourse-chart):

- [values.yaml](https://github.com/concourse/concourse-chart/blob/master/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add concourse https://concourse-charts.storage.googleapis.com/
helm repo update

# installs
helm upgrade --install concourse concourse/concourse --namespace concourse --create-namespace

# uninstalls
helm uninstall concourse -n concourse
kubectl delete ns concourse
```

## Examples

### Instruqt, Traefik, cert-manager, Let's Encrypt

```bash
DOMAIN=concourse.console.${_SANDBOX_ID}.instruqt.io

# installs the chart with helm
helm upgrade --install concourse concourse/concourse --namespace concourse --create-namespace \
  --set web.ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set web.ingress.enabled=true \
  --set web.ingress.hosts[0]=$DOMAIN \
  --set web.ingress.ingressClassName=traefik \
  --set web.ingress.tls[0].secretName=concourse-tls \
  --set web.ingress.tls[0].hosts[0]=$DOMAIN \
  --set concourse.web.externalUrl=https://$DOMAIN

# logs in (test/test by default)
fly --target localhost login --concourse-url https://$DOMAIN/
```

<!--
## Stable chart (deprecated)

See [helm/chart](https://github.com/helm/charts/tree/master/stable/concourse) ([values.yaml](https://github.com/helm/charts/blob/master/stable/concourse/values.yaml))

This is the old version but it works on AKS (just need to wait for all pods to be green, with attachment to pvc and startup).

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: concourse-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/issuer: letsencrypt-poc
spec:
  tls:
    - hosts:
        - my-domain.com
      secretName: domain-web-tls
  rules:
    - host: my-domain.com
      http:
        paths:
          - path: /
            backend:
              serviceName: concourse-stable-web
              servicePort: 8080
```

```bash
# create or configure the concourse ingress (edit the service name)
kubectl apply -f ingress.yaml

# activate ingress
helm install my-name stable/concourse --set concourse.web.externalUrl=https://my-domain.com/ --set web.ingress.enabled=true --set web.ingress.hosts[0]=my-domain.com --set web.ingress.tls[0].secretName=domain-web-tls --set web.ingress.tls[0].hosts[0]=my-domain.com --set secrets.localUsers="test:mysecretpassword" --set web.resources.requests.cpu="200m" --set web.resources.requests.memory="256Mi"
```

## Known issues

https://discuss.concourse-ci.org/t/concourse-installed-by-helm-chart/1819/5
https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#gzip-types
https://github.com/helm/charts/blob/master/stable/nginx-ingress/values.yaml
https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/
-->
