# Helm Charts

[![CI](https://github.com/devpro/helm-charts/actions/workflows/ci.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/ci.yml)

Helm charts to ease the deployment of containers on Kubernetes clusters.

## Content

* Applications
  * [E Corp Demo](./charts/ecorp-demo/README.md) 🗸
  * [WordPress](./charts/wordpress/README.md)
* Backing services
  * [Istio](./charts/istio/README.md)
  * [MongoDB](./charts/mongodb/README.md)
  * [RabbitMQ](./charts/rabbitmq/README.md)
* Kube add-ons
  * [ArgoCD](./charts/argocd/README.md)
  * [cert-manager](./charts/cert-manager/README.md) 🗸
  * cert-manager / Let's Encrypt
  * [NGINX Ingress Controller](./charts/ingress-nginx/README.md) 🗸
  * [Sealed Secrets](./charts/sealed-secrets/README.md) 🗸
* Observability
  * [OpenTelemetry Collector / Prometheus / Grafana](./charts/otel-prometheus-grafana/README.md)
* Security
  * [NeuVector](./charts/neuvector/README.md)
* Software Factory
  * [GitLab](./charts/gitlab/README.md)
  * [Harbor](./charts/harbor/README.md)
  * [SonarQube](./charts/sonarqube/README.md)

## Cluster setup logic

* Create Kubernetes Cluster and get access (download `kubectl` configuration)
* Install & configure kube add-ons
  * Install certificate issuer (cert-manager)
  * Create storage class
  * Create Ingress Controller (NGINX or HAProxy)
  * Create load balancer
  * Install secret management (Sealed Secrets)
  * Deploy GitOps tool (ArgoCD or Fleet)
* Setup Security (NeuVector)
* Install Observability (OpenTelemetry, Prometheus, Grafana)
* Setup Continuous Deployment
  * Configure GitOps repositories and deploy backing services and applications

## Limitations

* [Helm Chart Releaser](https://github.com/helm/chart-releaser) doesn't support multiple chart directories ou multiple levels so all charts must be in charts repository :(

## Local setup

### Validate

* Lint charts with [helm/chart-testing](https://github.com/helm/chart-testing) ([GitHub Action](https://github.com/marketplace/actions/helm-chart-testing))

```bash
# runs Docker image (with workaround described at https://github.com/helm/chart-testing/issues/464)
sudo docker run -it --workdir=/data --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.7.1 /bin/sh -c "git config --global --add safe.directory /data; ct list-changed --target-branch main --chart-dirs charts/applications"
```

### How to validate locally

## References

### CNCF

* [Cloud Native Interactive Landscape](https://landscape.cncf.io/)

### Inspirations

* Custom
  * [bashofmann/rancher-cluster-templates](https://github.com/bashofmann/rancher-cluster-templates) ([Pages](https://bashofmann.github.io/rancher-cluster-templates/))
  * [bitnami/charts](https://github.com/bitnami/charts)
* Products
  * [argoproj/argo-helm](https://github.com/argoproj/argo-helm)
  * [aws/eks-charts](https://github.com/aws/eks-charts)
  * [DataDog/helm-charts](https://github.com/DataDog/helm-charts)
  * [elastic/helm-charts](https://github.com/elastic/helm-charts)
  * [grafana/helm-charts](https://github.com/grafana/helm-charts)
  * [jfrog/charts](https://github.com/jfrog/charts)
  * [Kong/charts](https://github.com/Kong/charts)
  * [prometheus-community/helm-charts](https://github.com/prometheus-community/helm-charts)
