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
- `webapi.referenceData`: TMDB/RAWG/Discogs API keys and the Open Library book provider override,
  used to enrich movies/TV shows/video games/books/albums with posters, synopsis, cast and episode data (optional).
- `security.hardened.enabled`: runs containers with a read-only root filesystem, all Linux capabilities dropped, and the default seccomp profile,
  for platforms that mandate the Kubernetes Pod Security Standards "restricted" profile.
  Disabled by default; validate in a non-production environment first.

## Scaling & high availability

Both deployments support `replicaCount > 1`, by design of the app itself rather than of any particular ingress (no sticky sessions / cookie affinity required anywhere -
it works identically behind a Cloudflare tunnel, Traefik, ingress-nginx, or a plain `Service`).

**`webapi`** (requires app image >= the release that introduced the MongoDB-backed job store): fully stateless per request.
Background-job progress (TV Time import, reference-data "sync now") is stored in MongoDB so any replica can answer a poll,
and the daily reference-data sync elects a single runner through a MongoDB lease, so scaling out never multiplies TMDB/RAWG/Discogs traffic.

Just raise `webapi.replicaCount`.

**`blazorapp`** (Blazor Server): two settings make multiple replicas work, both on by the time you scale:

1. `blazorapp.dataProtection.enabled: true` (plus its MongoDB connection, typically the same secret as `webapi.db`) - shares the cookie-encryption key ring across replicas.
   Without it, a login cookie issued by one pod is unreadable by the others and users bounce between logged-in and logged-out.
   Worth enabling even at 1 replica: sessions then survive pod restarts.
2. `blazorapp.webSocketsOnly: true` (the default) -
   each Blazor circuit runs on one long-lived WebSocket and therefore naturally sticks to the pod that owns its in-memory state, with no load-balancer affinity needed.
   Whatever sits in front only has to pass WebSockets through (Cloudflare tunnels and every mainstream ingress do).

Known limitation (inherent to Blazor Server, not fixable by this chart): a circuit lives in the memory of exactly one pod.
When that pod dies or is replaced during a rollout, browsers connected to it reconnect and reload the page they were on
(no user data is lost - the app saves edits as they are made).
Extra replicas therefore add capacity and availability for new connections; they don't make an individual session survive the loss of its pod.
After a transient network blip (pod still alive), the client's reconnect attempts re-roll across replicas until one lands on the right pod,
which at small replica counts succeeds within the default retry budget.

## Development

Look at the [Contributing guide](CONTRIBUTING.md).
