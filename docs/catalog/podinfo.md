# Podinfo

Let's see how to run [Podinfo](https://github.com/stefanprodan/podinfo) in a Kubernetes cluster.

## Introduction

> Podinfo is a tiny web application made with Go that showcases best practices of running microservices in Kubernetes. Podinfo is used by CNCF projects like Flux and Flagger for end-to-end testing and workshops. ([github.com](https://github.com/stefanprodan/podinfo))

See also [golang.ch](https://golang.ch/a-tiny-web-application-golang-showcases-best-practices-of-running-microservices-in-kubernetes/)

## Configuration

We'll use the [official Helm chart](https://github.com/stefanprodan/podinfo/tree/master/charts/podinfo):

- [values.yaml](https://github.com/stefanprodan/podinfo/blob/master/charts/podinfo/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update

# installs
helm upgrade --install podinfo podinfo/podinfo --create-namespace --namespace podinfo

# uninstalls
helm uninstall podinfo -n podinfo
kubectl delete ns podinfo
```
