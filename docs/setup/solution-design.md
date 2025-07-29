# Solution design

## Cluster setup logic

* Create a Kubernetes Cluster and get CLI access (download `kubectl` configuration)
* Install & configure kube add-ons
  * Install certificate issuer ([cert-manager](../application-guides/cert-manager))
  * Create storage class
  * Create Ingress Controller ([NGINX](../application-guides/ingress-nginx) or HAProxy)
  * Create load balancer
  * Install secret management ([Sealed Secrets](../application-guides/sealed-secrets))
  * Deploy GitOps tool ([ArgoCD](../application-guides/argo-cd) or Fleet)
* Setup Security ([NeuVector](../application-guides/neuvector))
* Install Observability ([OpenTelemetry](../application-guides/opentelemetry-collector), [Granafa](../custom-charts/grafana-stack))
* Setup Continuous Deployment
  * Configure GitOps repositories and deploy backing services and applications
