# RabbitMQ

This Helm chart will install [RabbitMQ](https://www.rabbitmq.com/) ([docs](https://www.rabbitmq.com/documentation.html), [code](https://github.com/rabbitmq))
and is based from the [Bitnami Helm chart](https://bitnami.com/stack/rabbitmq/helm) ([code](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq)).

## How to create or update the chart

```bash
# adds helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# searches for the latest version
helm search repo -l rabbitmq

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

```bash
# checks the Kubernetes objects generated from the chart
helm template rabbitmq . -f values.yaml \
  --namespace rabbitmq > temp.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install rabbitmq . -f values.yaml --create-namespace \
  --namespace rabbitmq

# checks everything is ok
kubectl get svc,deploy,pod,ingress,pv,certificate -n rabbitmq

# displays RabbitMQ cluster status
kubectl exec rabbitmq-0 -n=rabbitmq -- rabbitmq-diagnostics cluster_status

# if needed, deletes the chart
helm uninstall rabbitmq -n rabbitmq
```

## How to start once the application is running

### Rabbit Management

* Have access to [Rabbit Management](https://www.rabbitmq.com/management.html)

```bash
# displays RabbitMQ cluster status
kubectl exec rabbitmq-0 -n=rabbitmq -- rabbitmq-diagnostics cluster_status

# retrieves generated password
kubectl get secret rabbitmq -n rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d

# tunnels calls to Rabbit Management (https://www.rabbitmq.com/management.html)
kubectl port-forward svc/rabbitmq 15672:15672 -n rabbitmq

# manual: open http://127.0.0.1:15672/ (and login with "user" as username and the password retrieved before)
```

## How to investigate

### Known issues

TODO
