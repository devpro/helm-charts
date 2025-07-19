# Traefik

Let's see how to run [Traefik](https://traefik.io/) ([docs](https://doc.traefik.io/traefik/), [code](https://github.com/traefik/traefik)) in a Kubernetes cluster.

## Configuration

We'll use the [official Helm chart](https://github.com/traefik/traefik-helm-chart):

- [blog](https://traefik.io/blog/install-and-configure-traefik-with-helm/)
- [examples](https://github.com/traefik/traefik-helm-chart/blob/master/EXAMPLES.md)
- [values.yaml](https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml)

## Deployment

```bash
# adds Helm chart repository
helm repo add traefik https://traefik.github.io/charts
helm repo update

# installs
helm upgrade --install traefik/traefik --namespace traefik --create-namespace

# uninstalls
helm uninstall traefik -n traefik
kubectl delete ns traefik
```
