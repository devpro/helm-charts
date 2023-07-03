# Helm chart for Kratos

This Helm chart will install [Kratos](https://www.ory.sh/kratos/) ([code](https://github.com/ory/kratos), [docs](https://www.ory.sh/docs/kratos/ory-kratos-intro)) on a Kubernetes cluster.
It is based on [the official Helm chart](https://k8s.ory.sh/helm/kratos.html) ([code](https://github.com/ory/k8s/tree/master/helm/charts/kratos)).

## Usage

```bash
# if not already done, adds devpro repository in helm
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update

# installs the chart with default parameters
helm upgrade --install kratos devpro/kratos --create-namespace --namespace kratos

# cleans up
helm uninstall kratos -n kratos
kubectl delete ns kratos
```

## Configuration

Setting up the authentication flow can be tricky. Here are some links with information that could help you.

* [Quickstart](https://www.ory.sh/docs/kratos/quickstart)
* [Kratos Helm chart hack values](https://github.com/ory/k8s/blob/master/hacks/values/kratos.yaml)

## Going further

Look at [Contibuting](CONTRIBUTING.md) page.
