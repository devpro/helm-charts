# Contribution guide

## Update chart dependencies

Add the Bitnami Helm repository:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Look for existing versions:

```bash
helm search repo -l mongodb --versions
```

Manually edit `Chart.yaml` with the version.

Update `Chart.lock` and fetch the archive into `charts/` (gitignored, rebuilt from `Chart.lock` by anyone who needs it):

```bash
helm dependency update .
```

Note: Bitnami's index currently redirects some downloads to `oci://registry-1.docker.io/bitnamicharts`, which can fail with a 401 for older versions.
The same `mongodb-18.6.16.tgz` is used by the sidelab and keeptrack charts — copying it from a sibling `charts/` directory is a valid workaround as long as the version matches.

## Review the generated manifest

```bash
helm template liveship . -f values.yaml -f values.mine.yaml --namespace liveship --debug > temp.yaml
```

Useful sanity checks on the output: `helm template liveship .` with nothing set must fail fast asking for a database;
`--set mongodb.enabled=true` alone must fail asking for `mongodb.auth.rootPassword`;
`--set ingress.enabled=true` without a host, or an `auth.encryptionKey` that isn't 64 hex characters, must fail with a clear message rather than render something broken.

## Validate on a local cluster

The image is private on GHCR for now — create the pull secret first:

```bash
kubectl create secret docker-registry ghcr-pull -n liveship \
  --docker-server=ghcr.io --docker-username=<github-user> --docker-password=<PAT-with-read:packages>
```

Then a minimal `values.mine.yaml` for a demo install:

```yaml
imagePullSecrets:
  - name: ghcr-pull
mongodb:
  enabled: true
  auth:
    rootPassword: "change-me"
```

```bash
helm upgrade --install liveship . -f values.mine.yaml --namespace liveship --create-namespace
```

Follow the printed NOTES.txt to seed the first admin user and port-forward to the app.
Verify login works end-to-end (that exercises MongoDB, `NEXTAUTH_SECRET`, and `NEXTAUTH_URL` at once), then create a connection and re-open it after `kubectl rollout restart` (that exercises `ENCRYPTION_KEY` stability).
