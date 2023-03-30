# Helm chart for Report Portal

This Helm chart will install [Report Portal](https://reportportal.io/) ([docs](https://reportportal.io/docs/), [code](https://github.com/reportportal))
and is based from the [official Helm chart](https://reportportal.github.io/kubernetes) ([code](https://github.com/reportportal/kubernetes)).

Report Portal chart has optional Helm dependencies on [Elasticsearch](https://github.com/elastic/helm-charts/tree/main/elasticsearch), [MinIO](https://github.com/bitnami/charts/tree/main/bitnami/minio/),
[PostgreSQL](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) and [RabbitMQ](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq/).

## How to use

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install reportportal devpro/reportportal --create-namespace \
  --namespace reportportal

# checks all pods are running after some time
kubectl get pod -n reportportal

# if needed, deletes the chart
helm uninstall reportportal -n reportportal
kubectl delete ns reportportal
```

## How to start once the application is running

👷 TODO

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add reportportal https://reportportal.github.io/kubernetes

# searches for the latest version
helm search repo -l reportportal

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template reportportal . -f values.yaml \
  --namespace reportportal > temp.yaml
```

## How to deploy manually from the sources

### Sample with cert-manager, Let's Encrypt & NGINX Ingress Controller

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install reportportal . -f values.yaml --create-namespace \
  --set reportportal.ingress.hosts[0]=reportportal.${NGINX_PUBLIC_IP}.sslip.io \
  --set reportportal.ingress.annotations.'cert-manager\.io/cluster-issuer'=selfsigned-cluster-issuer \
  --set reportportal.ingress.tls[0].hosts[0]=reportportal.${NGINX_PUBLIC_IP}.sslip.io \
  --set reportportal.ingress.tls[0].secretName=reportportal-tls \
  --set reportportal.elasticsearch.installdep.enable=true \
  --set reportportal.elasticsearch.replicas=1 \
  --set reportportal.elasticsearch.extraEnvs[0].name=discovery.type \
  --set reportportal.elasticsearch.extraEnvs[0].value=single-node \
  --set reportportal.elasticsearch.extraEnvs[0].name=cluster.initial_master_nodes \
  --set reportportal.elasticsearch.extraEnvs[0].value="" \
  --set reportportal.minio.installdep.enable=true \
  --set reportportal.minio.endpoint="http://reportportal-minio.default.svc.cluster.local:9000" \
  --set reportportal.minio.endpoint=reportportal-minio.default.svc.cluster.local:9000 \
  --set reportportal.minio.accesskey=admin \
  --set reportportal.minio.secretkey=admin \
  --set reportportal.minio.auth.rootUser=admin \
  --set reportportal.minio.auth.rootPassword=admin \
  --set reportportal.postgresql.installdep.enable=true \
  --set reportportal.postgresql.endpoint.address=reportportale-postgresql.default.svc.cluster.local \
  --set reportportal.postgresql.endpoint.user=rpuser \
  --set reportportal.postgresql.endpoint.password=rpuser \
  --set reportportal.postgresql.endpoint.dbName=reportportal \
  --set reportportal.postgresql.global.postgresql.auth.username=rpuser \
  --set reportportal.postgresql.global.postgresql.auth.password=rpuser \
  --set reportportal.postgresql.global.postgresql.auth.database=reportportal \
  --set reportportal.rabbitmq.installdep.enable=true \
  --set reportportal.rabbitmq.endpoint.address=reportportale-rabbitmq.default.svc.cluster.local \
  --set reportportal.rabbitmq.endpoint.password=rabbitmq \
  --set reportportal.rabbitmq.auth.username=rabbitmq \
  --set reportportal.rabbitmq.auth.password=rabbitmq \
  --namespace reportportal
```
