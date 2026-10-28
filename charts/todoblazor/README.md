# Helm chart for Todo Blazor

This Helm chart will deploy [Todo Blazor](https://github.com/devpro/todo-blazor) on a Kubernetes cluster.

## Usage

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the application:

```bash
helm upgrade --install todoblazor devpro/todoblazor -f values.yaml --namespace demo --create-namespace
```

## Going further

Check the [contribution guide](CONTRIBUTING.md).
