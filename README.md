# Helm Charts

[![CI](https://github.com/devpro/helm-charts/actions/workflows/ci.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/ci.yml)
[![PKG](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml)

Helm charts to ease the deployment of containers on Kubernetes clusters and get information on widely used components.

## Quickstart

* Visit [devpro.github.io/helm-charts](https://devpro.github.io/helm-charts/)

## Catalog

* Applications
  * [Cow Demo](charts/cow-demo/README.md) 🗸
  * [Devpro Sales Portal](charts/devpro-salesportal/README.md) 🗸
  * [Drupal](charts/drupal/README.md)
  * [E Corp Demo](charts/ecorp-demo/README.md) 🗸
  * [Game 2048](charts/game-2048/README.md) 🗸
  * [HobbyFarm](charts/hobbyfarm/README.md) 🗸
  * [Podinfo](charts/podinfo/README.md) 🗸
  * [WordPress](charts/wordpress/README.md) 🗸
* Authentication / Identity
  * [Keycloak](charts/keycloak/README.md) 🗸
  * [Kratos](charts/kratos/README.md) 🗸
* Cloud providers
  * [Azure Storage](charts/azure-storage/README.md) 🗸
  * [Outscale](charts/outscale/README.md)
* Data stores
  * [Elasticsearch](charts/elasticsearch/README.md) 🗸
  * [MariaDB](charts/mariadb/README.md) 🗸
  * [memcached](charts/memcached/README.md)
  * [MongoDB (Bitnami)](charts/mongodb-bitnami/README.md) 🗸
  * [MongoDB Community](charts/mongodb-community/README.md) 🗸
  * [PostgreSQL](charts/postgresql/README.md) 🗸
  * [RabbitMQ](charts/rabbitmq/README.md) 🗸
  * [Redis](charts/redis/README.md) 🗸
* Networking & Messaging
  * [cert-manager](charts/cert-manager/README.md) 🗸
  * [Consul](charts/consul/README.md)
  * [external-dns](charts/external-dns/README.md)
  * [HAProxy](charts/haproxy/README.md)
  * [Istio](charts/istio/README.md)
  * [Kafka](charts/kafka/README.md)
  * [Kong](charts/kong/README.md)
  * [Let's Encrypt](charts/letsencrypt/README.md) 🗸
  * [Linkerd](charts/linkerd/README.md)
  * [MetalLB](charts/metallb/README.md)
  * [MQTT](charts/mqtt/README.md)
  * [NATS](charts/nats/README.md) 🗸
  * [NGINX Ingress Controller](charts/ingress-nginx/README.md) 🗸
  * [Traefik](charts/traefik/README.md) 🗸
* Management
  * [Rancher](charts/rancher/README.md) 🗸
  * [Rancher Cluster Templates](charts/rancher-cluster-templates/README.md) 🗸
* Observability
  * [Elastic Stack](charts/elastic-stack/README.md)
  * [Grafana Stack](charts/grafana-stack/README.md) 🗸
  * [OpenTelemetry Collector](charts/opentelemetry-collector/README.md) 🗸
  * [Prometheus](charts/prometheus/README.md) 🗸
  * Splunk
* Platforms
  * [Epinio](charts/epinio/README.md) 🗸
* Secrets
  * [Sealed Secrets](charts/sealed-secrets/README.md) 🗸
* Security
  * [NeuVector](charts/neuvector/README.md) 🗸
  * [Rancher CIS Benchmark](charts/rancher-cis-benchmark/README.md) 🗸
* Serverless
  * [Knative](charts/knative/README.md)
* Storage
  * [Kasten K10](charts/kasten-k10/README.md) 🗸
  * [Longhorn](charts/longhorn/README.md) 🗸
  * [MinIO](charts/minio/README.md) 🗸
  * [s3gw](charts/s3gw/README.md) 🗸
  * [NFS-Ganesha](charts/nfs-ganesha/README.md) 🗸
* Supply Chain (Software Factory)
  * [ArgoCD](charts/argo-cd/README.md) 🗸
  * [Argo Rollouts](charts/argo-rollouts/README.md)
  * [Artifactory](charts/artifactory/README.md)
  * [Azure DevOps Agent](charts/azure-devops-agent/README.md)
  * [CloudBees CI](charts/cloudbees-ci/README.md) 🗸
  * [Concourse](charts/concourse/README.md)
  * [Drone](charts/drone/README.md)
  * [GitLab](charts/gitlab/README.md) 🗸
  * [GitLab Runner](charts/gitlab-runner/README.md) 🗸
  * [Harbor](charts/harbor/README.md) 🗸
  * [Jenkins](charts/jenkins/README.md) 🗸
  * [Jira](charts/jira/README.md)
  * [Nexus](charts/nexus/README.md)
  * [R2Devops](charts/r2devops/README.md) 🗸
  * [Promyze](charts/promyze/README.md) 🗸
  * [SonarQube](charts/sonarqube/README.md) 🗸
  * [Tekton](charts/tekton/README.md)
* Testing
  * [Report Portal](charts/reportportal/README.md) 🗸

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

## Local setup

### How to validate a code change

* Lint charts with [helm/chart-testing](https://github.com/helm/chart-testing)

```bash
# runs in a container (with workaround described at https://github.com/helm/chart-testing/issues/464)
docker run --rm -it --workdir=/data --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.7.1 /bin/sh -c "git config --global --add safe.directory /data ; ./scripts/add_helm_repo.sh ; ct lint --target-branch main"
```

* (not yet available because of [Issue #575](https://github.com/stackrox/kube-linter/issues/575)) Lint charts with [stackrox/kube-linter](https://github.com/stackrox/kube-linter) ([docs](https://docs.kubelinter.io/))

```bash
# runs in a container
docker run --rm -v $(pwd)/charts:/charts -v $(pwd)/.kube-linter.yaml:/etc/config.yaml stackrox/kube-linter lint /charts --config /etc/config.yaml
```

## References

* Cloud Native components
  * [Cloud Native Interactive Landscape](https://landscape.cncf.io/)
* Documentation
  * [Rancher How-to Guides > Helm Charts > Creating Apps](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/helm-charts-in-rancher/create-apps)
* Examples
  * [argoproj/argocd-example-apps](https://github.com/argoproj/argocd-example-apps)
  * [helm/charts](https://github.com/helm/charts)
  * [rancher/rodeo](https://github.com/rancher/rodeo)
* Official repositories
  * [argoproj/argo-helm](https://github.com/argoproj/argo-helm)
  * [aws/eks-charts](https://github.com/aws/eks-charts)
  * [bitnami/charts](https://github.com/bitnami/charts)
  * [elastic/helm-charts](https://github.com/elastic/helm-charts)
  * [grafana/helm-charts](https://github.com/grafana/helm-charts)
  * [prometheus-community/helm-charts](https://github.com/prometheus-community/helm-charts)
  * [rancher/charts](https://github.com/rancher/charts)
  * [rancher/helm3-charts](https://github.com/rancher/helm3-charts)
