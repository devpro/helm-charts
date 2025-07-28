# Helm Charts

[![CI](https://github.com/devpro/helm-charts/actions/workflows/ci.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/ci.yml)
[![PKG](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml)

This repository provides a list of community, vendor and home Helm charts to easily configure and run workloads in Kubernetes clusters.
Feel free to [contribute](CONTRIBUTING.md)!

Get started with the [documentation](https://devpro.github.io/helm-charts/docs/).

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

## Samples

* [DevOpsDays Geneva 2023](samples/devopsdays-geneva-2023/README.md)
* [SUSE Exchange Paris 2023](samples/suse-exchange-paris-2023/README.md)
