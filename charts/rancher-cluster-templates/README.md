# Helm chart for Rancher cluster templates

This Helm chart gives the possibility to create and manage a Kubernetes cluster from Rancher thanks to [Rancher Cluster Templates](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/manage-clusters/manage-cluster-templates).

> [!NOTE]
> Inspired by examples from [bloriot](https://github.com/bloriot/rancher-cluster-templates) and [rancher](https://github.com/rancher/cluster-template-examples).

## Getting started

Start with the [documentation](https://kwt.devpro.fr/custom-charts/rancher-cluster-templates.html).

## Configuration

💡 Node driver must be enabled in Rancher prior to Helm chart installation

Provider                         | Example                                                  | Template                                                  | Node Driver
---------------------------------|----------------------------------------------------------|-----------------------------------------------------------|----------------
**Amazon Web Services (AWS)**    | [values_aws](examples/values_aws.yaml)                   | [amazonec2config](templates/amazonec2config.yaml)         | `Amazon EC2`
**Azure**                        | [values_azure](examples/values_azure.yaml)               | [azureconfig](templates/azureconfig.yaml)                 | `Azure`
**CloudScale**                   | [values_cloudscale](examples/values_cloudscale.yaml)     | [cloudscaleconfig](templates/cloudscaleconfig.yaml)       | `Cloudscale`
**Digitial Ocean**               | [values_digitalocean](examples/values_digitalocean.yaml) | [digitaloceanconfig](templates/digitaloceanconfig.yaml)   | `DigitalOcean`
**Exoscale**                     | [values_digitalocean](examples/values_digitalocean.yaml) | [digitaloceanconfig](templates/digitaloceanconfig.yaml)   | `Exoscale`
**Equinix Metal (prev. Packet)** | [values_equinix](examples/values_equinix.yaml)           | [packetconfig](templates/packetconfig.yaml)               | `Equinix Metal`
**Harvester**                    | [values_harvester](examples/values_harvester.yaml)       | [harvesterconfig](templates/harvesterconfig.yaml)         | `Harvester`
**Linode**                       | [values_linode](examples/values_linode.yaml)             | [linodeconfig](templates/linodeconfig.yaml)               | `Linode`
**Nutanix**                      | [values_nutanix](examples/values_nutanix.yaml)           | [nutanixconfig](templates/nutanixconfig.yaml)             | `Nutanix`
**OpenStack**                    | [values_openstack](examples/values_openstack.yaml)       | [openstackconfig](templates/openstackconfig.yaml)         | `OpenStack`
**Outscale**                     | [values_aws](examples/values_outscale.yaml)              | [outscaleconfig](templates/outscaleconfig.yaml)           | `Outscale`
**VMware vSphere**               | [values_vsphere](examples/values_vsphere.yaml)           | [vmwarevsphereconfig](templates/vmwarevsphereconfig.yaml) | `vSphere`

## Usage

Add chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file by looking at configuration examples.

Install the chart in the Kubernetes cluster hosting Rancher:

```bash
helm upgrade --install my-cluster devpro/rancher-cluster-templates -f values.yaml --namespace fleet-default
```
