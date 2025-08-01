# Solution design

## Cluster setup logic

* Create a Kubernetes Cluster and get CLI access (download `kubectl` configuration)
* Install & configure kube add-ons
  * Install certificate issuer ([cert-manager](../application-guides/security/cert-manager))
  * Create storage class
  * Create Ingress Controller ([NGINX](../application-guides/networking/nginx) or HAProxy)
  * Create load balancer
  * Install secret management ([Sealed Secrets](../application-guides/security/sealed-secrets))
  * Deploy GitOps tool ([ArgoCD](../application-guides/pipeline-orchestration/argo-cd) or Fleet)
* Setup Security ([NeuVector](../application-guides/security/neuvector))
* Install Observability ([OpenTelemetry](../application-guides/observability/opentelemetry-collector), [Granafa](../custom-charts/grafana-stack))
* Setup Continuous Deployment
  * Configure GitOps repositories and deploy backing services and applications
