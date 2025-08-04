# ReportPortal

Let's see how to run [ReportPortal](https://reportportal.io/) ([docs](https://reportportal.io/docs/), [code](https://github.com/reportportal)) in a Kubernetes cluster.

## Dependencies

ReportPortal chart has optional Helm dependencies:

- [Elasticsearch](https://github.com/elastic/helm-charts/tree/main/elasticsearch)
- [MinIO](https://github.com/bitnami/charts/tree/main/bitnami/minio/)
- [PostgreSQL](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
- [RabbitMQ](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq/)

## Configuration

We'll use the [official Helm chart](https://reportportal.github.io/kubernetes) ([code](https://github.com/reportportal/kubernetes)):

- [values.yaml](https://github.com/SonarSource/helm-chart-sonarqube/blob/master/charts/sonarqube/values.yaml)

And dependant configuration:

```yaml
# https://github.com/elastic/helm-charts/blob/main/elasticsearch/values.yaml
elasticsearch: {}
# https://github.com/bitnami/charts/blob/main/bitnami/minio/values.yaml
minio: {}
# https://github.com/bitnami/charts/blob/main/bitnami/postgresql/values.yaml
postgresql: {}
# https://github.com/bitnami/charts/blob/main/bitnami/rabbitmq/values.yaml
rabbitmq: {}
```

## Deployment

```bash
# adds Helm chart repository
helm repo add reportportal https://reportportal.github.io/kubernetes
helm repo update

# installs
helm upgrade --install reportportal reportportal/reportportal --namespace reportportal --create-namespace

# checks everything is ok
kubectl get pod -n reportportal

# uninstalls
helm uninstall reportportal -n reportportal
kubectl delete ns reportportal
```

## Examples

### NGINX, sslip.io, cert-manager, Let's Encrypt

Install the Helm chart:

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# installs the application
helm upgrade --install reportportal reportportal/reportportal --namespace reportportal --create-namespace \
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
  --set reportportal.rabbitmq.auth.password=rabbitmq
```
