# Kube Workload Toolkit

[![CI](https://github.com/devpro/helm-charts/actions/workflows/ci.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/ci.yml)
[![PKG](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml/badge.svg)](https://github.com/devpro/helm-charts/actions/workflows/pkg.yml)

Welcome! This project provides:

- **Curated guides**: Step-by-step instructions for installing popular applications using their official Helm charts in a Kubernetes cluster.
- **Custom Helm charts**: A collection of charts that were created for deploying unique workloads on Kubernetes.

Whether you're deploying custom solutions or setting up well-known applications like NGINX or Prometheus, this repository aims to simplify your Kubernetes journey with tested configurations and clear documentation.

🚀 Get started with the [Kube Workload Toolkit](https://kwt.devpro.fr/)

Feel free to [contribute](CONTRIBUTING.md)!

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


## Samples

* [DevOpsDays Geneva 2023](samples/devopsdays-geneva-2023/README.md)
* [SUSE Exchange Paris 2023](samples/suse-exchange-paris-2023/README.md)
