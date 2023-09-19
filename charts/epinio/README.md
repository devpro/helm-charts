# Helm chart for Epinio

This Helm chart will install [Epinio](https://epinio.io/) on a Kubernetes cluster.
It is based on the [official Helm chart](https://artifacthub.io/packages/helm/epinio/epinio).

## Introduction

> Epinio is an application Platform. It deploys on Kubernetes and allows application developers and operators to work together without stepping on each others work. ([docs.epinio.io](https://docs.epinio.io/))

More information on [rancher-ecosystem/epinio](https://devpro.github.io/rancher-ecosystem/epinio/).

## Quick start

- Install Epinio in a Kubernetes cluster

💡 `cert-manager` must be installed

```bash
# makes sure devpro helm repository has been added
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update

# installs the chart with default parameters
helm upgrade --install epinio devpro/epinio --create-namespace --namespace epinio

# removes the installation
helm uninstall epinio -n epinio
kubectl delete ns epinio
```

- Download [`epinio` (Epinio CLI)](https://github.com/epinio/epinio/releases/) and use it to manage workload

## Going further

Look at the [Contributing](CONTRIBUTING.md) page.
