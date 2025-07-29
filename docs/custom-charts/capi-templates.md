# Cluster API (CAPI) Templates

Let's see how to simplify the use of CAPI (Cluster API) to manage your Kubernetes clusters.

## Repository

This is a custom chart:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

## Usage

### Create GKE (Google Cloud Kubernetes Engine) cluster

Initialize CAPI:

```bash
export GCP_B64ENCODED_CREDENTIALS=$(cat $GCLOUD_SERVICEACCOUNT_KEYSFILE | base64 | tr -d '\n')
export EXP_CAPG_GKE=true
clusterctl init --infrastructure gcp
```

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

Create the cluster:

```bash
helm upgrade --install capi-gke-demo devpro/capi-templates -f values_gke.yaml --namespace demo --create-namespace
```

Look at the cluster provisioning:

```bash
kubectl get cluster -n demo
clusterctl describe cluster gke-capi-bthomas-demo -n demo
```

Delete resources:

```bash
helm delete capi-gke-demo -n demo
while kubectl get cluster gke-capi-bthomas-demo -n demo &>/dev/null; do sleep 1; done
kubectl delete ns demo
```
