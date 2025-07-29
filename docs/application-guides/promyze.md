# Promyze

Let's see how to run [Promyze](https://www.promyze.com/) in a Kubernetes cluster.

We'll use the [official Helm chart](https://promyze.github.io/helm-charts/) ([code](https://github.com/promyze/helm-charts), [docs](https://docs.promyze.com/on-premise-version/install-the-self-hosted-version)).

## Configuration

Create the `values.yaml` file to override [default parameters](https://github.com/promyze/helm-charts/blob/main/charts/promyze/values.yaml).

## Deployment

Add Helm chart repository:

```bash
helm repo add promyze https://promyze.github.io/helm-charts
helm repo update
```

Install the application:

```bash
helm upgrade --install promyze promyze/promyze -f values.yaml --namespace promyze --create-namespace
```

Uninstall and clean the cluster:

```bash
helm uninstall promyze -n promyze
kubectl delete ns promyze
```
