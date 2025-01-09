# Contribute

## Quality check

```bash
# lints (code style)
helm lint
```

## Deployment from the sources

### GKE (Google Cloud Kubernetes Engine)

Initialize CAPI:

```bash
export GCP_B64ENCODED_CREDENTIALS=$(cat $GCLOUD_SERVICEACCOUNT_KEYSFILE | base64 | tr -d '\n')
export EXP_CAPG_GKE=true
clusterctl init --infrastructure gcp
```

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

Generate the manifest file for review:

```bash
helm template capi-gke-demo . -f values.yaml -f values_gke.yaml > temp.yaml
```

Can be compared with the one generated with clusterctl:

```bash
export GCP_PROJECT=$GCLOUD_PROJECT_ID
export GCP_REGION=$GCLOUD_REGION
export GCP_NETWORK_NAME=$GCLOUD_VPC
export WORKER_MACHINE_COUNT=1
clusterctl generate cluster gke-capi-bthomas-demo --flavor gke -i gcp  > capi-gke-quickstart.yaml
```

Apply changes with Helm:

```bash
helm upgrade --install capi-gke-demo . -f values.yaml -f values_gke.yaml --namespace demo --create-namespace
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
