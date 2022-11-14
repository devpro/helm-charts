# Helm Charts

[![CI](https://github.com/devpro/helm-charts/actions/workflows/ci.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/ci.yml)
[![PKG](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml)

Helm charts to ease the deployment of containers on Kubernetes clusters.

## Catalog

* Applications
  * [E Corp Demo](./charts/ecorp-demo/README.md) 🗸
  * [WordPress](./charts/wordpress/README.md) 🗸
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
* Software Factory (supply chain)
  * [GitLab](./charts/gitlab/README.md)
  * [Harbor](./charts/harbor/README.md)
  * [SonarQube](./charts/sonarqube/README.md)

Limitation: [Helm Chart Releaser](https://github.com/helm/chart-releaser) doesn't support multiple chart directories ou multiple levels so all charts must be in `charts` repository

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
