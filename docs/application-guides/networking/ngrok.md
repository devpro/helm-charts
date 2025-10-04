# ngrok

Let's see how to run [ngrok](https://ngrok.com/) in a Kubernetes cluster with the [ngrok Kubernetes Operator](https://ngrok.com/docs/k8s).

## Introduction

ngrok Kubernetes Operator was announced in June of 2023, read the [blog post](https://ngrok.com/blog-post/ngrok-k8s) to know more about it.

## Authentication

Log in [dashboard.ngrok.com](https://dashboard.ngrok.com/) and retrieve the information:

Key       | Dashboard page
----------|-------------------------------------------------------------------------
AUTHTOKEN | [Your Authtoken](https://dashboard.ngrok.com/get-started/your-authtoken)
API_KEY   | [API Keys](https://dashboard.ngrok.com/api-keys)

## Domain reservation

Go to [dashboard.ngrok.com/domains](https://dashboard.ngrok.com/domains) and click **New Domain**.

## Repository

We'll use the [official Helm chart](https://github.com/ngrok/ngrok-operator/tree/main/helm/ngrok-operator):

```bash
helm repo add ngrok https://charts.ngrok.com
helm repo update
```

## Configuration

Create the `values.yaml` file to override [default parameters.yaml](https://github.com/ngrok/ngrok-operator/blob/main/helm/ngrok-operator/values.yaml).

::: code-group

```yaml [Default]
# replicaCount: 1
# image:
#   registry: docker.io
#   repository: ngrok/ngrok-operator
#   tag: ""
# log:
#   format: json
#   level: info
#   stacktraceLevel: error
```

```yaml [Secret credentials]
# kubectl create secret generic --namespace ngrok ngrok-operator-credentials --from-literal=AUTHTOKEN=[AUTHTOKEN] --from-literal=API_KEY=[API_KEY]
credentials:
  secret:
    name: "ngrok-credentials"
```

```yaml [Raw credentials]
credentials:
  apiKey: "[AUTHTOKEN]"
  authtoken: "[API_KEY]"
```

:::

## Deployment

Install the application:

```bash
helm upgrade --install ngrok-operator ngrok/ngrok-operator -f values.yaml --namespace ngrok --create-namespace
```

Watch objects being created:

```bash
kubectl get pod -n ngrok
```

> [!TIP]
> A new ingress class has been created with the default name `ngrok`

## Usecases

- [Ingress](https://ngrok.com/docs/getting-started/kubernetes/ingress)
- [Gateway API](https://ngrok.com/docs/getting-started/kubernetes/gateway-api)
- [Endpoints](https://ngrok.com/docs/getting-started/kubernetes/endpoints)

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm uninstall ngrok-operator -n ngrok
kubectl delete ns ngrok
```

## Integrations

- [Kubernetes ingress to applications and clusters managed by Rancher](https://ngrok.com/docs/integrations/kubernetes-ingress/rancher-k8s#kubernetes-ingress-to-applications-and-clusters-managed-by-rancher)
