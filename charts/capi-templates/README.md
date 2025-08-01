# Kubernetes CAPI Templates Helm Chart

This chart will simplify the use of [Cluster API (CAPI))](https://cluster-api.sigs.k8s.io/) to manage your Kubernetes clusters.

## Getting started

Start with the [documentation](https://kwt.devpro.fr/custom-charts/capi-templates.html).

## Usage

### Setup

Add the Helm repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

### Create GKE cluster

Create the configuration file:

```bash
cat <<EOF > values_gke.yaml
name: gke-capi-$USER-demo
type: gke
googlecloud:
  project: $GCLOUD_PROJECT_ID
  region: $GCLOUD_REGION
  vpc: $GCLOUD_VPC
  zone: $GCLOUD_ZONE
  subnet:
    name: $GCLOUD_SUBNET
EOF
```

Generate the manifest file for review:

```bash
helm template capi-gke-demo devpro/capi-templates -f values_gke.yaml > temp.yaml
```

Can be compared with the one generated with clusterctl:

```bash
export GCP_PROJECT=$GCLOUD_PROJECT_ID
export GCP_REGION=$GCLOUD_REGION
export GCP_NETWORK_NAME=$GCLOUD_VPC
export WORKER_MACHINE_COUNT=1
clusterctl generate cluster gke-capi-bthomas-demo --flavor gke -i gcp  > capi-gke-quickstart.yaml
```

Create the cluster:

```bash
helm install capi-gke-demo devpro/capi-templates -f values_gke.yaml
```
