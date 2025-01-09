# Kubernetes CAPI Templates Helm Chart

This chart will simplify the use of CAPI (Cluster API) to manage your Kubernetes clusters.

Contributions are welcome! See how with this [short guide](CONTRIBUTING.md).

## Getting started

### Setup

Add the Helm repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

### GKE (Google Cloud Kubernetes Engine)

Configure the cluster:

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

Creates the cluster:

```bash
helm install capi-gke-demo devpro/capi-templates -f values_gke.yaml
```
