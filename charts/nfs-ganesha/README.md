# Helm chart for NFS-Ganesha

This Helm chart will install [NFS-Ganesha](https://nfs-ganesha.github.io/) ([code](https://github.com/nfs-ganesha/nfs-ganesha)) on a Kubernetes cluster.

## Installation

```bash
# installs the chart with default parameters
helm upgrade --install nfs-ganesha devpro/nfs-ganesha --create-namespace --namespace nfs-ganesha
```

## Open collaboration

Look at the [contributing guide](CONTRIBUTING.md).
