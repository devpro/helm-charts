# Helm chart for Promyze

This Helm chart will install [Promyze](https://www.promyze.com/) in a Kubernetes cluster.
It is based on the [official Helm chart](https://promyze.github.io/helm-charts/) ([code](https://github.com/promyze/helm-charts),
[docs](https://docs.promyze.com/on-premise-version/install-the-self-hosted-version)).

## Usage

```bash
# if not already done, adds devpro repository in helm
helm repo add promyze https://promyze.github.io/helm-charts
helm repo update

# installs the chart with default parameters
helm upgrade --install promyze devpro/promyze --create-namespace --namespace promyze

# cleans up
helm uninstall promyze -n promyze
kubectl delete ns promyze
```

## Going further

Look at [Contibuting](CONTRIBUTING.md) page.
