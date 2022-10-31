# Helm Charts

Helm charts to ease the deployment of containers on Kubernetes clusters.

## Content

* Applications
  * [E Corp Demo](./charts/applications/ecorp-demo/README.md) 🗸
  * [WordPress](./charts/applications/wordpress/README.md)
* Backing services
  * [Istio](./charts/backing-services/istio/README.md)
  * [MongoDB](./charts/backing-services/mongodb/README.md)
  * [RabbitMQ](./charts/backing-services/rabbitmq/README.md)
* Kube add-ons
  * [ArgoCD](./charts/kube-addons/argocd/README.md)
  * [cert-manager](./charts/kube-addons/cert-manager/README.md) 🗸
  * cert-manager / Let's Encrypt
  * [NGINX Ingress Controller](./charts/kube-addons/ingress-nginx/README.md) 🗸
  * [Sealed Secrets](./charts/kube-addons/sealed-secrets/README.md) 🗸
* Observability
  * [OpenTelemetry Collector / Prometheus / Grafana](./charts/observability/otel-prometheus-grafana/README.md)
* Security
  * [NeuVector](./charts/security/neuvector/README.md)
* Software Factory
  * [GitLab](./charts/software-factory/gitlab/README.md)
  * [Harbor](./charts/software-factory/harbor/README.md)
  * [SonarQube](./charts/software-factory/sonarqube/README.md)

## Cluster setup steps

* Create Kubernetes Cluster and get access (download `kubectl` configuration)
* Install & configure kube add-ons
  * Install certificate issuer (cert-manager)
  * Create storage class
  * Create Ingress Controller (NGINX or HAProxy)
  * Create load balancer
  * Install secret management (Sealed Secrets)
  * Deploy GitOps tool (ArgoCD or Fleet)
* Setup Security (NeuVector)
* Install Observability (OpenTelemetry, Prometheus, Grafana)
* Setup Continuous Deployment
  * Configure GitOps repositories and deploy backing services and applications

## References

### CNCF

* [Cloud Native Interactive Landscape](https://landscape.cncf.io/)

### Inspirations

* Custom
  * [bashofmann/rancher-cluster-templates](https://github.com/bashofmann/rancher-cluster-templates) ([Pages](https://bashofmann.github.io/rancher-cluster-templates/))
  * [bitnami/charts](https://github.com/bitnami/charts)
* Products
  * [argoproj/argo-helm](https://github.com/argoproj/argo-helm)
  * [aws/eks-charts](https://github.com/aws/eks-charts)
  * [DataDog/helm-charts](https://github.com/DataDog/helm-charts)
  * [elastic/helm-charts](https://github.com/elastic/helm-charts)
  * [grafana/helm-charts](https://github.com/grafana/helm-charts)
  * [jfrog/charts](https://github.com/jfrog/charts)
  * [Kong/charts](https://github.com/Kong/charts)
  * [prometheus-community/helm-charts](https://github.com/prometheus-community/helm-charts)
