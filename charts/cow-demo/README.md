# Cow demo application Helm chart

Helm chart to deploy cow demonstration application.

## How to check chart

```bash
# lints the chart
helm lint .

# creates Kubernetes template file from chart
helm template cow-demo . -f values.yaml --namespace demo > temp.yaml
```

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install cow-demo . -f values.yaml --namespace demo \
--set pet.color=green \
--set host=cow-demo.${NGINX_PUBLIC_IP}.sslip.io \
--set ingress.annotations.'cert-manager\.io/cluster-issuer'=selfsigned-cluster-issuer \
--set ingress.enabled=true \
--create-namespace

# checks everythings is ok
kubectl get all -n demo
kubectl get Secrets,Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges -n demo

# manual: open in a browser http://cow-demo.${NGINX_PUBLIC_IP}.sslip.io

# if needed, deletes the chart
helm delete cow-demo -n demo
```

## How to get application source code and image

### AMD64

* [devprofr/cow-demo](https://hub.docker.com/r/devprofr/cow-demo) ([code](https://github.com/devpro/container-images/tree/main/src/cow-demo))
