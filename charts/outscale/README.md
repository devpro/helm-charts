# Helm chart for Outscale Cloud

This Helm chart will install Outscale Cloud CCM and CSI on a Kubernetes cluster.
It is based on Outscale Helm charts ([CCM](https://github.com/outscale/cloud-provider-osc/blob/OSC-MIGRATION/docs/helm.md), [CSI](https://github.com/outscale/osc-bsu-csi-driver/tree/master/osc-bsu-csi-driver)).

💡 Kubernetes objects will be installed in `kube-system` namespace

## How to use

- Create a Kubernetes secret called `osc-secret`

- With Helm CLI (see [README](../../README.md#from-helm-cli) for requirements)

```bash
# install with default parameters
helm upgrade --install outscale devpro/outscale --create-namespace \
  --namespace kube-system

# watches the installation and checks all pods are running after some time
# TODO
```

## How to create or update the chart

```bash
# searches for the latest version
helm show all oci://registry-1.docker.io/outscalehelm/osc-cloud-controller-manager
helm show all oci://registry-1.docker.io/outscalehelm/osc-bsu-csi-driver

# (optional) checks the template
helm template outscale oci://registry-1.docker.io/outscalehelm/osc-cloud-controller-manager > temp.yaml
helm template outscale oci://registry-1.docker.io/outscalehelm/osc-bsu-csi-driver > temp.yaml

# manual: get latest version and update it in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually from the sources

```bash
# creates the release from the local files
helm upgrade --install outscale . -f values.yaml --create-namespace \
  --namespace kube-system

# if needed, deletes the release
helm uninstall outscale -n kube-system
```
