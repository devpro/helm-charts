# Helm Charts

[![CI](https://github.com/devpro/helm-charts/actions/workflows/ci.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/ci.yml)
[![PKG](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml)

Helm charts to ease the deployment of containers on Kubernetes clusters and get information on widely used components.

## Quickstart

* Visit [devpro.github.io/helm-charts](https://devpro.github.io/helm-charts/)

## Catalog

* Applications
  * [E Corp Demo](charts/ecorp-demo/README.md) 🗸
  * [Drupal](charts/drupal/README.md)
  * [WordPress](charts/wordpress/README.md) 🗸
* Backing services
  * [Kafka](charts/kafka/README.md)
  * [Keycloak](charts/keycloak/README.md) 🗸
  * [MariaDB](charts/mariadb/README.md) 🗸
  * [memcached](charts/memcached/README.md)
  * [MongoDB](charts/mongodb/README.md)
  * [MQTT](charts/mqtt/README.md)
  * [PostgreSQL](charts/postgresql/README.md)
  * [RabbitMQ](charts/rabbitmq/README.md)
  * [Redis](charts/redis/README.md)
* Cloud providers
  * [Azure Storage](charts/azure-storage/README.md) 🗸
  * [Let's Encrypt](charts/letsencrypt/README.md) 🗸
* Kube add-ons
  * [ArgoCD](charts/argo-cd/README.md) 🗸
  * [cert-manager](charts/cert-manager/README.md) 🗸
  * [external-dns](charts/external-dns/README.md)
  * [HAProxy](charts/haproxy/README.md)
  * [Istio](charts/istio/README.md)
  * [Kong](charts/kong/README.md)
  * [Longhorn](charts/longhorn/README.md)
  * [MetalLB](charts/metallb/README.md)
  * [MinIO](charts/minio/README.md)
  * [NGINX Ingress Controller](charts/ingress-nginx/README.md) 🗸
  * [Sealed Secrets](charts/sealed-secrets/README.md) 🗸
* Observability
  * [Elastic Stack](charts/elastic-stack/README.md)
  * [Elasticsearch](charts/elasticsearch/README.md)
  * [OpenTelemetry Collector / Prometheus / Grafana](charts/otel-prometheus-grafana/README.md)
* Security
  * [NeuVector](charts/neuvector/README.md) 🗸
* Software Factory (supply chain)
  * [Artifactory](charts/artifactory/README.md)
  * [Azure DevOps Agent](charts/azure-devops-agent/README.md)
  * [Concourse](charts/concourse/README.md)
  * [Drone](charts/drone/README.md)
  * [GitLab](charts/gitlab/README.md) 🗸
  * [GitLab Runner](charts/gitlab-runner/README.md)
  * [Harbor](charts/harbor/README.md) 🗸
  * [Jira](charts/jira/README.md)
  * [Nexus](charts/nexus/README.md)
  * [SonarQube](charts/sonarqube/README.md) 🗸
  * [Tekton](charts/tekton/README.md)

Limitation: [Helm Chart Releaser](https://github.com/helm/chart-releaser) doesn't support multiple chart directories ou multiple levels so all charts must be in `charts` repository

## Usage

### From Helm CLI

```bash
# adds the Helm repository
helm repo add devpro https://devpro.github.io/helm-charts

# searches for a specific package from the command line
helm repo search <package_name>

# installs a package
helm install <package_name>
```

### From ArgoCD

* Create a git repository to store Kubernetes definition files (GitOps approach)

```yaml
# wordpress/Chart.yaml
apiVersion: v2
name: wordpress
description: Helm chart for installing WordPress
type: application
version: 0.1.0
appVersion: 1.0.0
dependencies:
  - name: wordpress
    version: 0.1.1
    repository: https://devpro.github.io/helm-charts
```

* Create a new application in ArgoCD to reference the git repository with the path to the folder

### From Fleet

* Create a git repository to store Kubernetes definition files (GitOps approach)

```yaml
# wordpress/fleet.yaml
defaultNamespace: sample-apps
helm:
  repo: https://devpro.github.io/helm-charts
  chart: wordpress
  version: 0.1.1
  releaseName: wordpress
```

* Create a GitRepo to reference the git repository with the path to the folder

## Cluster setup logic

* Create a Kubernetes Cluster and get CLI access (download `kubectl` configuration)
* Install & configure kube add-ons
  * Install certificate issuer ([cert-manager](./charts/cert-manager/README.md))
  * Create storage class
  * Create Ingress Controller ([NGINX](./charts/ingress-nginx/README.md) or HAProxy)
  * Create load balancer
  * Install secret management ([Sealed Secrets](./charts/sealed-secrets/README.md))
  * Deploy GitOps tool ([ArgoCD](./charts/argocd/README.md) or Fleet)
* Setup Security ([NeuVector](./charts/neuvector/README.md))
* Install Observability ([OpenTelemetry, Prometheus, Grafana](./charts/otel-prometheus-grafana/README.md))
* Setup Continuous Deployment
  * Configure GitOps repositories and deploy backing services and applications

## Local setup

### How to validate a code change

* Lint charts with [helm/chart-testing](https://github.com/helm/chart-testing)

```bash
# runs Docker image (with workaround described at https://github.com/helm/chart-testing/issues/464)
sudo docker run -it --workdir=/data --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.7.1 /bin/sh -c "git config --global --add safe.directory /data; ct list-changed --target-branch main"
```

## References

* Cloud Native components
  * [Cloud Native Interactive Landscape](https://landscape.cncf.io/)
* Examples
  * [argoproj/argocd-example-apps](https://github.com/argoproj/argocd-example-apps)
  * [rancher/rodeo](https://github.com/rancher/rodeo)
* Official repositories
  * [argoproj/argo-helm](https://github.com/argoproj/argo-helm)
  * [aws/eks-charts](https://github.com/aws/eks-charts)
  * [bitnami/charts](https://github.com/bitnami/charts)
  * [elastic/helm-charts](https://github.com/elastic/helm-charts)
  * [grafana/helm-charts](https://github.com/grafana/helm-charts)
  * [prometheus-community/helm-charts](https://github.com/prometheus-community/helm-charts)
