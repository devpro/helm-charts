# MySQL

Let's see how to run [MySQL](https://www.mysql.com/) in a Kubernetes cluster with [MySQL Operator for Kubernetes](https://dev.mysql.com/doc/mysql-operator/en/).

## Configuration

We'll use the [official Helm chart](https://dev.mysql.com/doc/mysql-operator/en/mysql-operator-installation-helm.html) ([code](https://github.com/mysql/mysql-operator)):

- [values.yaml](https://github.com/mysql/mysql-operator/blob/trunk/helm/mysql-operator/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add mysql-operator https://mysql.github.io/mysql-operator/
helm repo update

# installs
helm upgrade --install mysql-operator mysql-operator/mysql-operator --namespace mysql --create-namespace

# checks everything is ok
kubectl get pod -n mysql

# uninstalls
helm uninstall mysql -n mysql
kubectl delete ns mysql
```

<!-- The ouput of this command is very interesting:

  MySQL can be accessed via port 3306 on the following DNS name from within your cluster: mysql-xxxxxxx.default.svc.cluster.local

  To get your root password run: `MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default mysql-xxxxxxx -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)`

  To connect to your database:

  1. Run an Ubuntu pod that you can use as a client: `kubectl run -i --tty ubuntu --image=ubuntu:18.04 --restart=Never -- bash -il`

  2. Install the mysql client: `$ apt-get update && apt-get install mysql-client -y`

  3. Connect using the mysql cli, then provide your password: `$ mysql -h mysql-xxxxxxx -p`

  To connect to your database directly from outside the K8s cluster: MYSQL_HOST=127.0.0.1, MYSQL_PORT=3306. Execute the following command to route the connection: `kubectl port-forward svc/mysql-xxxxxxx 3306` and `mysql -h ${MYSQL_HOST} -P${MYSQL_PORT} -u root -p${MYSQL_ROOT_PASSWORD}`.

As usual, look at the progress with `kubectl get pods` ("STATUS" column).

At the end, clean your cluster `helm uninstall mysql-xxxxxxx`. -->
