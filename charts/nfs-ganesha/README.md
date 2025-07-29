# Helm chart for NFS-Ganesha

This Helm chart will install [NFS-Ganesha](https://nfs-ganesha.github.io/) ([code](https://github.com/nfs-ganesha/nfs-ganesha)) on a Kubernetes cluster.

## Usage

Installs the application:

```bash
helm upgrade --install nfs-ganesha devpro/nfs-ganesha --namespace nfs-ganesha --create-namespace
```
