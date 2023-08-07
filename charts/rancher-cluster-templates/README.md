# Helm chart for Kratos

This Helm chart will create a Kubernetes cluster from Rancher through [Cluster Templates](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/manage-clusters/manage-cluster-templates).

## Usage

```bash
# makes sure adds devpro Helm repository has been added
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update

# installs the chart with default parameters
helm upgrade --install my-cluster rancher-cluster-templates -f values.yaml --namespace fleet-default

# removes the installation
helm uninstall my-cluster -n fleet-default
```

For more information, look at the [general usage](https://github.com/devpro/helm-charts#usage) section.

## Configuration

TODO

## Contributing

Look at the [guide](CONTRIBUTING.md).

## Inspirations

* [bloriot/rancher-cluster-templates](https://github.com/bloriot/rancher-cluster-templates)
* [rancher/cluster-template-examples](https://github.com/rancher/cluster-template-examples)
