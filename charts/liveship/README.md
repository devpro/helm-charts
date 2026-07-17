# Liveship Helm Chart

Helm chart for [Liveship](https://github.com/devpro/liveship) — one platform for an organization's infrastructure, security posture, and code.
Deploys the Liveship application (Next.js + MongoDB), which reads the same database [terraform-backend-mongodb](../terraform-backend-mongodb) writes to — point both charts at the same MongoDB to get the Terraform state views.

`values.yaml` is the source of truth for every option — it's fully commented.

## Quick Start

Add the chart repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

Create a `values.yaml` file to override [default values](values.yaml).
Two things are always required:

- **Image pull credentials** — the `ghcr.io/devpro/liveship` image is private for now:

  ```bash
  kubectl create secret docker-registry ghcr-pull -n liveship \
    --docker-server=ghcr.io --docker-username=<github-user> --docker-password=<PAT-with-read:packages>
  ```

  then set `imagePullSecrets: [{name: ghcr-pull}]`.
- **A MongoDB** — one of `database.uri`, `database.existingSecret`, or `mongodb.enabled=true` (bundled demo instance; also set `mongodb.auth.rootPassword`).
  The chart fails fast at render time when none is set.

Install the application:

```bash
helm upgrade --install liveship devpro/liveship -f values.yaml --namespace liveship --create-namespace
```

`NEXTAUTH_SECRET` and `ENCRYPTION_KEY` are auto-generated on first install and kept stable across upgrades.
Under GitOps (ArgoCD/Flux), set `auth.existingSecret` instead — offline rendering would rotate them on every sync, and a rotated `ENCRYPTION_KEY` makes stored connection credentials permanently undecryptable (see `values.yaml`).

The first admin user is seeded with the `seed-admin.mjs` script from the liveship repo — `helm install` prints the exact commands (NOTES.txt).

## Scaling & high availability

The app is stateless and scales horizontally with no extra configuration: set `replicaCount` (or `autoscaling.enabled=true`), optionally with `podDisruptionBudget.enabled=true`.

What makes this safe (verified against the app's source):

- Sessions are stateless NextAuth JWT cookies — any replica can validate any user's cookie, since all replicas share the chart's single `NEXTAUTH_SECRET`.
  No sticky sessions needed.
- All application state and every cache (Kubernetes resource-type discovery, git repository cache, login lockout counters) live in MongoDB, shared by all replicas.
- Stored credentials are encrypted with the shared `ENCRYPTION_KEY` env var — every replica can decrypt what any other stored.
- Nothing is written to the local filesystem, and there are no in-process background jobs to run twice.

## Uninstall

```bash
helm uninstall liveship -n liveship
kubectl delete namespace liveship
```

The auto-generated `<release>-auth` Secret is deleted along with the namespace — its `ENCRYPTION_KEY` is the only way to decrypt stored connection credentials, so back it up first if the database outlives the release.
