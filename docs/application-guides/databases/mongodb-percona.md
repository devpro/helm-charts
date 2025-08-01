# MongoDB by Percona

Let's see how to run MongoDB in a Kubernetes cluster, using Percona distribution.

See [How to Run MongoDB on Kubernetes: Solutions, Pros and Cons](https://www.percona.com/blog/run-mongodb-in-kubernetes-solutions-pros-and-cons/) - January 5, 2024

## Configuration

We'll use the Percona Helm chart ([docs](https://docs.percona.com/percona-operator-for-mongodb/helm.html), [code](https://github.com/percona/percona-helm-charts)).

## Deployment

```bash
kubectl create namespace mongodb-percona

# https://github.com/percona/percona-helm-charts/blob/main/charts/psmdb-operator/values.yaml
helm upgrade --install psmdb-operator percona/psmdb-operator --namespace mongodb-percona

# https://github.com/percona/percona-helm-charts/blob/main/charts/psmdb-db/values.yaml
cat <<EOF | tee values_nosharding.yml
sharding:
  enabled: false
  balancer:
    enabled: true
configrs:
  size: 1
replsets:
  - name: rs0
    size: 2
    affinity:
      antiAffinityTopologyKey: "kubernetes.io/hostname"
    podDisruptionBudget:
      maxUnavailable: 1
    expose:
      enabled: false
      exposeType: ClusterIP
    resources:
      limits:
        cpu: "300m"
        memory: "0.5G"
      requests:
        cpu: "300m"
        memory: "0.5G"
    volumeSpec:
      pvc:
        resources:
          requests:
            storage: 3Gi
    nonvoting:
      enabled: false
      size: 3
      affinity:
        antiAffinityTopologyKey: "kubernetes.io/hostname"
      podDisruptionBudget:
        maxUnavailable: 1
      resources:
        limits:
          cpu: "300m"
          memory: "0.5G"
        requests:
          cpu: "300m"
          memory: "0.5G"
      volumeSpec:
        pvc:
          resources:
            requests:
              storage: 3Gi
    arbiter:
      enabled: false
      size: 1
      affinity:
        antiAffinityTopologyKey: "kubernetes.io/hostname"
EOF

helm upgrade --install psmdb-db1 percona/psmdb-db -f values_nosharding.yml --namespace mongodb-percona

# issues with upgrades...

# cleans up
helm delete psmdb-db1 -n mongodb-percona
helm delete psmdb-operator -n mongodb-percona
kubectl delete ns mongodb-percona
```
