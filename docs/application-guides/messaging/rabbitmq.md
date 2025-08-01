# RabbitMQ

Let's see how to run [RabbitMQ](https://www.rabbitmq.com/) ([docs](https://www.rabbitmq.com/documentation.html), [code](https://github.com/rabbitmq)) in a Kubernetes cluster.

## Configuration

We'll use the [Bitnami Helm chart](https://bitnami.com/stack/rabbitmq/helm) ([code](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq)):

- [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/rabbitmq/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# installs
helm upgrade --install rabbitmq bitnami/rabbitmq --namespace rabbitmq --create-namespace

# checks all pods are running
kubectl get svc,deploy,pod,ingress,pv,certificate -n rabbitmq

# displays RabbitMQ cluster status
kubectl exec rabbitmq-0 -n=rabbitmq -- rabbitmq-diagnostics cluster_status

# uninstalls
helm uninstall rabbitmq -n rabbitmq
kubectl delete ns rabbitmq
```

## Examples

### Minimalist footprint

```yaml
replicaCount: 1
```

## Enable calls from another namespace

```yaml
networkPolicy:
  enabled: true
  allowExternal: false
  additionalRules: []
```

### Authentication with hard-coded password

```yaml
auth:
  username: myyser
  password: "myp@ass0rd"
  securePassword: false
```

## Usage

## Access Rabbit Management

Retrieve generated password:

```bash
kubectl get secret rabbitmq -n rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d
```

Create a tunnel:

```bash
kubectl port-forward svc/rabbitmq 15672:15672 -n rabbitmq
```

Open [Rabbit Management](https://www.rabbitmq.com/management.html) from [127.0.0.1:15672](http://127.0.0.1:15672/) and log in with "user" as username and the password retrieved before.
