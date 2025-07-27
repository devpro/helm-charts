# Helm Charts

[![CI](https://github.com/devpro/helm-charts/actions/workflows/ci.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/ci.yml)
[![PKG](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml)

This repository provides a list of community, vendor and home Helm charts to easily configure and run workloads in Kubernetes clusters.
Feel free to [contribute](CONTRIBUTING.md)!

Latest chart versions are available from [devpro.github.io/helm-charts](https://devpro.github.io/helm-charts/).

## Catalog

* Applications
  * [Cow Demo](charts/cow-demo/README.md)
  * [Devpro Sales Portal](charts/devpro-salesportal/README.md)
  * [Drupal](docs/upstream/drupal.md)
  * [E Corp Demo](charts/ecorp-demo/README.md)
  * [Game 2048](charts/game-2048/README.md)
  * [HobbyFarm](charts/hobbyfarm/README.md)
  * [Podinfo](docs/upstream/podinfo.md)
  * [WordPress](charts/wordpress/README.md)
* Authentication / Identity
  * [Keycloak](charts/keycloak/README.md)
  * [Kratos](charts/kratos/README.md)
* Cloud providers
  * [Azure Storage](charts/azure-storage/README.md)
  <!-- * [Outscale](charts/outscale/README.md) -->
* Data stores
  * [Elasticsearch](docs/upstream/elasticsearch.md)
  * [MariaDB](docs/upstream/mariadb.md)
  <!-- * [memcached](docs/upstream/memcached.md) -->
  * [MongoDB (Bitnami)](charts/mongodb-bitnami/README.md)
  * [MongoDB Community](charts/mongodb-community/README.md)
  * [PostgreSQL](docs/upstream/postgresql.md)
  * [RabbitMQ](docs/upstream/rabbitmq.md)
  * [Redis](docs/upstream/redis.md)
* Infrastucture automation
  * [Terraform Backend MongoDB](charts/terraform-backend-mongodb)
* Networking & Messaging
  * [cert-manager](docs/upstream/cert-manager.md)
  <!-- * [Consul](docs/upstream/consul.md) -->
  * [external-dns](docs/upstream/external-dns.md)
  <!-- * [HAProxy](docs/upstream/haproxy.md)
  * [Istio](docs/upstream/istio.md)
  * [Kafka](docs/upstream/kafka.md)
  * [Kong](docs/upstream/kong.md) -->
  * [Let's Encrypt](charts/letsencrypt/README.md)
  <!-- * [Linkerd](docs/upstream/linkerd.md)
  * [MetalLB](docs/upstream/metallb.md)
  * [MQTT](docs/upstream/mqtt.md) -->
  * [NATS](docs/upstream/nats.md)
  * [NGINX Ingress Controller](docs/upstream/ingress-nginx.md)
  * [Traefik](docs/upstream/traefik.md)
* Management
  * [Rancher](docs/upstream/rancher.md)
  * [Rancher Cluster Templates](charts/rancher-cluster-templates/README.md)
* Observability
  <!-- * [Elastic Stack](docs/upstream/elastic-stack.md) -->
  * [Grafana Stack](charts/grafana-stack/README.md)
  * [OpenTelemetry Collector](charts/opentelemetry-collector/README.md)
  * [Prometheus](docs/upstream/prometheus.md)
  * Splunk
* Platforms
  * [Epinio](docs/upstream/epinio.md)
* Secrets
  * [Sealed Secrets](docs/upstream/sealed-secrets.md)
* Security
  * [NeuVector](charts/neuvector/README.md)
  * [Rancher CIS Benchmark](docs/upstream/rancher-cis-benchmark.md)
<!-- * Serverless
  * [Knative](docs/upstream/knative.md) -->
* Storage
  * [Kasten](docs/upstream/kasten.md)
  * [Longhorn](docs/upstream/longhorn.md)
  * [MinIO](charts/minio/README.md)
  * [s3gw](docs/upstream/s3gw.md)
  * [NFS-Ganesha](charts/nfs-ganesha/README.md)
* Supply Chain (Software Factory)
  * [Argo CD](docs/upstream/argo-cd.md)
  <!-- * [Argo Rollouts](docs/upstream/argo-rollouts.md)
  * [Artifactory](docs/upstream/artifactory.md)
  * [Azure DevOps Agent](docs/upstream/azure-devops-agent.md) -->
  * [CloudBees CI](docs/upstream/cloudbees-ci.md)
  * [Concourse](docs/upstream/concourse.md)
  <!-- * [Drone](docs/upstream/drone.md) -->
  * [GitLab](charts/gitlab/README.md)
  * [GitLab Runner](charts/gitlab-runner/README.md)
  * [Harbor](docs/upstream/harbor.md)
  * [Jenkins](docs/upstream/jenkins.md)
  <!-- * [Jira](docs/upstream/jira.md)
  * [Nexus](docs/upstream/nexus.md) -->
  * [R2Devops](charts/r2devops/README.md)
  * [Promyze](charts/promyze/README.md)
  * [SonarQube](docs/upstream/sonarqube.md)
  <!-- * [Tekton](docs/upstream/tekton.md) -->
* Testing
  * [Report Portal](docs/upstream/reportportal.md)

Limitation: [Helm Chart Releaser](https://github.com/helm/chart-releaser) doesn't support multiple chart directories ou multiple levels so all charts must be in `charts` repository

## Best pratices

* [Operations](docs/operations.md)

## Samples

* [DevOpsDays Geneva 2023](samples/devopsdays-geneva-2023/README.md)
* [SUSE Exchange Paris 2023](samples/suse-exchange-paris-2023/README.md)

## Usage

### From Helm CLI

```bash
# checks helm is installed
helm version

# if not already done, adds devpro repository in helm
helm repo add devpro https://devpro.github.io/helm-charts

# refreshes helm repository informations
helm repo update

# searches for a specific package from the command line
helm search repo -l <package_name>

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

### From Rancher

* In your cluster
  * Go to "Apps" > "Repositories", click on "Create" and enter `https://devpro.github.io/helm-charts` as "Index URL", then click on "Create"
  * Go to "Apps" > "Charts", look at the available applications (charts) and install the one(s) you want

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
