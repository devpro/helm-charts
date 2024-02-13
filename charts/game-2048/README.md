# Helm chart for game 2048

This Helm chart will install Game 2048 on a Kubernetes cluster.

## Usage

[Helm](https://helm.sh) must be installed to use the chart from the command line. Here is the flow to have the application running in your Kubernetes cluster:

```bash
# adds the repo (if not already done)
helm repo add devpro https://devpro.github.io/helm-charts

# retrieves recent information from added repos
helm repo update

# installs the chart (this command can be ran multiple times)
helm upgrade --install game-2048 devpro/game-2048 --create-namespace --namespace sample-apps
```

Once done, uninstall the chart and clean-up the cluster:

```bash
helm delete game-2048
kubectl delete ns sample-apps
```
