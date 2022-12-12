# Traefik

This Helm chart will install [Traefik](https://traefik.io/) ([docs](https://doc.traefik.io/traefik/), [code](https://github.com/traefik/traefik))
and is based from the [official Helm chart](https://github.com/traefik/traefik-helm-chart) ([blog](https://traefik.io/blog/install-and-configure-traefik-with-helm/), [examples](https://github.com/traefik/traefik-helm-chart/blob/master/EXAMPLES.md)).

## How to update the chart

```bash
# adds helm chart repository
helm repo add traefik https://traefik.github.io/charts
helm repo update

# searches for the latest version
helm search repo -l traefik

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update

# checks the Kubernetes objects generated from the chart
helm template . -f values.yaml > temp.yaml
```

## How to deploy manually

```bash
# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install -f values.yaml --create-namespace \
  --namespace traefik traefik .

# checks everything is ok
#TODO

# if needed, deletes the chart
helm uninstall traefik -n traefik
```

## How to investigate

```bash
# checks existings resources
#TODO
```
