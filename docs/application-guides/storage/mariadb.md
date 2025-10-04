# MariaDB

```bash
# installs MariaDB
helm upgrade --install mariadb bitnami/mariadb --namespace mariadb-system --create-namespace \
  --set global.storageClass=longhorn

# checks the pod (state should be Running)
kubectl get pod -n mariadb-system

# checks the persistent volume and claims (status should be Bound)
kubectl get pvc,pv -n mariadb-system

# cleans-up resources
helm delete mariadb -n mariadb-system
kubectl delete persistentvolumeclaim/data-mariadb-0 -n mariadb-system
```
