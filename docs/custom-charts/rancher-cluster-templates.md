# Rancher Cluster Templates

Let's see how to automate [Rancher Cluster Templates](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/manage-clusters/manage-cluster-templates) to ease cluster management with Rancher.

## Infrastructure providers

> [!IMPORTANT]
> Node driver must be enabled in Rancher prior to Helm chart installation.

Provider                         | Template              | Node Driver
---------------------------------|-----------------------|----------------
**Amazon Web Services (AWS)**    | `amazonec2config`     | `Amazon EC2`
**Azure**                        | `azureconfig`         | `Azure`
**CloudScale**                   | `cloudscaleconfig`    | `Cloudscale`
**Digitial Ocean**               | `digitaloceanconfig`  | `DigitalOcean`
**Exoscale**                     | `digitaloceanconfig`  | `Exoscale`
**Equinix Metal (prev. Packet)** | `packetconfig`        | `Equinix Metal`
**Harvester**                    | `harvesterconfig`     | `Harvester`
**Linode**                       | `linodeconfig`        | `Linode`
**Nutanix**                      | `nutanixconfig`       | `Nutanix`
**OpenStack**                    | `openstackconfig`     | `OpenStack`
**Outscale**                     | `outscaleconfig`      | `Outscale`
**VMware vSphere**               | `vmwarevsphereconfig` | `vSphere`

## Repository

Make sure to have the **devpro** Helm repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

## Configuration

Create the `values.yaml` file to override [default parameters](https://github.com/devpro/helm-charts/blob/main/charts/rancher-cluster-templates/values.yaml).

::: code-group

```bash [Azure]
cp examples/values_azure.yaml values_mine.yaml
resourcekey=$(openssl rand -hex 6)
sed -i "s/CLUSTER_NAME/az-rke2-$resourcekey/g" values_mine.yaml
sed -i "s/AZURE_PREFIX/$USER-$resourcekey/g" values_mine.yaml
sed -i "s/CLOUD_CREDENTIAL_SECRET/<secret_name>/g" values_mine.yaml
```

```bash [Outscale]
cp examples/values_outscale.yaml values_mine.yaml
resourcekey=$(openssl rand -hex 6)
sed -i "s/CLUSTER_NAME/az-rke2-$resourcekey/g" values_mine.yaml
sed -i "s/CLOUD_CREDENTIAL_SECRET/<secret_name>/g" values_mine.yaml
```

:::

## Deployment

> [!IMPORTANT]
> Make sure you are connected to the Kubernetes cluster hosting Rancher (called `local` by default in Rancher).

Install the application:

```bash
helm upgrade --install mycluster devpro/rancher-cluster-templates -f values.yaml --namespace fleet-default
```

## Troubleshooting

Start by looking at the machine-provision job (in `fleet-default` namespace).

If there are remaining Kubernetes resources even after helm uninstall, force delete the machine.

## Automation (GitOps)

### Fleet example for creating RKE2 cluster in Azure

::: code-group

```yaml [fleet.yaml]
helm:
  repo: https://devpro.github.io/helm-charts
  chart: rancher-cluster-templates
  version: 0.1.1
  releaseName: rke2-azure-demo
  values:
    cluster:
      name: "azurevm-rke2-01"
    cloudprovider: azure
    cloudCredentialSecretName: cattle-global-data:cc-xxxx
    kubernetesVersion: "v1.24.14+rke2r1"
    nodepools:
      - etcd: true
        controlplane: true
        worker: true
        quantity: 1
        name: nodepool-1
        region: westeurope
        machineImage: "Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:20.04.202307240"
        instanceType: Standard_DS2_v2
        storageType: Standard_LRS
        sshUser: azureuser
        availabilitySet: "avs-someprefix-rke2-01"
        azureEnvironment: AzurePublicCloud
        managedDisks: true
        networkSecurityGroup: "nsg-someprefix-rke2-01"
        resourceGroup: "rg-someprefix-rke2-01"
        subnet: rke2
        subnetPrefix: "192.168.0.0/16"
        virtualNetwork: "vnet-someprefix-rke2-01"
```

```yaml [GitRepo]
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: cluster-templates
  namespace: fleet-local
spec:
  branch: release/demo
  clientSecretName: auth-xxxx
  insecureSkipTLSVerify: false
  paths:
    - fleet/rke2-azure-demo
  repo: https://github.com/my-account/my-kubernetes-definitions.git
  targets:
    - clusterSelector:
        matchExpressions:
          - key: provider.cattle.io
            operator: NotIn
            values:
              - harvester
```

:::

## Clean-up

Uninstall the application and delete the namespace:

```bash
helm uninstall mycluster -n fleet-default
```
