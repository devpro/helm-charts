# Helm chart for Kratos

This Helm chart will create a Kubernetes cluster from Rancher through [Cluster Templates](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/manage-clusters/manage-cluster-templates).

## Usage

### Quickstart

```bash
# double checks you are on Rancher local cluster
kubectl get nodes

# makes sure adds devpro Helm repository has been added
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update

# installs the chart with default parameters
helm upgrade --install my-cluster rancher-cluster-templates -f values.yaml --namespace fleet-default

# removes the installation
helm uninstall my-cluster -n fleet-default
```

### Going further

* GitOps approach
  * [ArgoCD](https://github.com/devpro/helm-charts#from-argocd)
  * [Fleet](https://github.com/devpro/helm-charts#from-fleet)
* [Rancher Apps](https://github.com/devpro/helm-charts#from-rancher)

## Configuration

### Infrastructure providers

Provider                              | Examples                                                 | Templates                                               | Node Driver
--------------------------------------|----------------------------------------------------------|---------------------------------------------------------|----------------
**Amazon Web Services (AWS)**         | [values_aws](examples/values_aws.yaml)                   | [amazonec2config](templates/amazonec2config.yaml)       | `Amazon EC2`
**Azure**                             | [values_azure](examples/values_azure.yaml)               | [azureconfig](templates/azureconfig.yaml)               | `Azure`
**CloudScale**                        | [values_cloudscale](examples/values_cloudscale.yaml)     | [cloudscaleconfig](templates/cloudscaleconfig.yaml)     | `Cloudscale`
**Digitial Ocean**                    | [values_digitalocean](examples/values_digitalocean.yaml) | [digitaloceanconfig](templates/digitaloceanconfig.yaml) | `DigitalOcean`
**Exoscale**                          | [values_digitalocean](examples/values_digitalocean.yaml) | [digitaloceanconfig](templates/digitaloceanconfig.yaml) | `Exoscale`
**Equinix Metal (previously Packet)** | [values_equinix](examples/values_equinix.yaml)           | [packetconfig](templates/packetconfig.yaml)             | `Equinix Metal`
**Harvester**                         | [values_harvester](examples/values_harvester.yaml)       | [harvesterconfig](templates/harvesterconfig.yaml)       | `Harvester`
**Linode**                            | [values_linode](examples/values_linode.yaml)             | [linodeconfig](templates/linodeconfig.yaml)             | `Linode`
**Nutanix**                           | [values_nutanix](examples/values_nutanix.yaml)           | [nutanixconfig](templates/nutanixconfig.yaml)           | `Nutanix`
**OpenStack**                         | [values_openstack](examples/values_openstack.yaml)       | [openstackconfig](templates/openstackconfig.yaml)       | `OpenStack`
**Outscale**                          | [values_aws](examples/values_outscale.yaml)              | [outscaleconfig](templates/outscaleconfig.yaml)         | `Outscale`
**VMware vSphere**                    | [values_vsphere](examples/values_vsphere.yaml)           | [vsphereconfig](templates/vsphereconfig.yaml)           | `vSphere`

## Contributing

Follow the [guide](CONTRIBUTING.md).

## Inspirations

* [bloriot/rancher-cluster-templates](https://github.com/bloriot/rancher-cluster-templates)
* [rancher/cluster-template-examples](https://github.com/rancher/cluster-template-examples)
