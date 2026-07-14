# Helm chart for Devpro Keeptrack

This is the official Helm chart to install [Keeptrack](https://github.com/devpro/keeptrack) on a Kubernetes cluster.

## Getting started

Start with the [documentation](https://kwt.devpro.fr/custom-charts/keeptrack.html).

## Usage

Add [Helm](https://helm.sh) repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create the `values.yaml` file to override [default values](values.yaml).

Install the application:

```bash
helm upgrade --install keeptrack devpro/keeptrack -f values.yaml --create-namespace --namespace keeptrack
```

Uninstall the chart and clean-up the cluster:

```bash
helm delete keeptrack
kubectl delete ns keeptrack
```

## Configuration

See [values.yaml](values.yaml) for the full list of settings.

Notable ones:

- `webapi.db`: MongoDB connection (mandatory).
- `firebase`: authentication configuration (mandatory).
- `webapi.referenceData`: TMDB/RAWG/Discogs API keys and the Open Library book provider override, used to
  enrich movies/TV shows/video games/books/albums with posters, synopsis, cast and episode data (optional -
  a missing key just means that provider's enrichment silently fails).
- `security.hardened.enabled`: runs containers with a read-only root filesystem, all Linux capabilities
  dropped, and the default seccomp profile, for platforms that mandate the Kubernetes Pod Security
  Standards "restricted" profile. Disabled by default; validate in a non-production environment first.

## Development

Look at the [Contributing guide](CONTRIBUTING.md).
