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

## Review the generated manifest

```bash
helm template sidelab . -f values.yaml -f values.mine.yaml --namespace sidelab --debug > temp.yaml
```

Useful sanity checks on the output: the same value should never appear twice from two different sources (that's what the top-level `domain` value and reusing `ingress.className`/`ingress.tls`/the cert-manager annotation for lab sessions are for), and `--set database.backend=mongo` with nothing else set, or `--set ingress.enabled=true` with no `domain`/`ingress.host`, should fail fast with a clear `fail` message rather than render something broken.

## Validate on MicroK8s

This is the fastest local loop — no cloud cluster, no DNS, no cert-manager required for the base cases below.

### 0. Point Helm/kubectl at MicroK8s

If your default `helm`/`kubectl` context points somewhere else (a cloud cluster, etc.), either use MicroK8s' own bundled tooling:

```bash
microk8s helm3 <command>
microk8s kubectl <command>
```

or export MicroK8s' kubeconfig for the rest of this session:

```bash
microk8s config > /tmp/microk8s-kubeconfig.yaml
export KUBECONFIG=/tmp/microk8s-kubeconfig.yaml
```

Both were used interchangeably while validating this chart — pick whichever you already have muscle memory for.

### 1. Build and import the images

MicroK8s can't `docker pull` images that only exist in your local Docker daemon — import them explicitly. From the `sidelab` repo:

```bash
docker compose --profile build-only build
docker tag sidelab-app:latest sidelab-app:v1   # avoid :latest — see docs/wsl-microk8s.md
docker save sidelab-launcher:latest | microk8s images import -
docker save sidelab-app:v1 | microk8s images import -
```

`microk8s images import` reports success/failure via its exit code, not via `microk8s ctr images list` — that command needs `sudo` and silently prints nothing without it. The reliable way to confirm an image actually landed is to deploy and check the Pod's events:

```bash
kubectl describe pod -n sidelab -l app.kubernetes.io/name=sidelab | grep -A2 Events
```

`Pulled ... already present on machine` means it's there; `ErrImageNeverPull`/`ImagePullBackOff` means the import didn't take (or the tag doesn't match) — re-run the `docker save | microk8s images import -` step. This state is not persistent across every MicroK8s restart — a `microk8s stop`/`start` cycle (or one triggered by a snap refresh) can clear the image cache, so re-check before assuming a stale import is still good.

### 2. Known-good `values.mine.yaml` combinations

Point `image.repository`/`launcher.labImage` at the locally-imported tags in every scenario below (MicroK8s doesn't need the registry path prefix — plain `sidelab-launcher`/`sidelab-app` resolve to what you imported).

#### a. Zero-config default — SQLite + NodePort

No `values.mine.yaml` needed at all:

```bash
microk8s helm3 upgrade --install sidelab . \
  --namespace sidelab --create-namespace \
  --set image.repository=sidelab-launcher --set image.tag=latest \
  --set launcher.labImage=sidelab-app:v1
```

Retrieve the auto-generated admin password and log in:

```bash
kubectl get secret -n sidelab sidelab-auth -o jsonpath='{.data.ADMIN_PASSWORD}' | base64 -d; echo
kubectl port-forward -n sidelab svc/sidelab 3000:3000
```

#### b. SQLite + Ingress, on MicroK8s' bundled ingress-nginx

MicroK8s registers ingress classes `public` and `nginx` once `microk8s enable ingress` has run (see `docs/microk8s-ingress.md` in the sidelab repo for the full mirrored-networking setup). No cert-manager here — plain HTTP, `nip.io` wildcard DNS:

```yaml
domain: "127.0.0.1.nip.io"
ingress:
  enabled: true
  className: "public"
launcher:
  labAccess: "ingress"
```

```bash
microk8s helm3 upgrade --install sidelab . -f values.mine.yaml \
  --namespace sidelab --create-namespace \
  --set image.repository=sidelab-launcher --set image.tag=latest \
  --set launcher.labImage=sidelab-app:v1
```

Dashboard ends up at `http://sidelab.127.0.0.1.nip.io`, lab sessions at `http://<session-id>.labs.127.0.0.1.nip.io`.

#### c. MongoDB — bundled chart, disposable demo

```yaml
database:
  backend: "mongo"
mongodb:
  enabled: true
  auth:
    rootPassword: "demo12345"   # required — see the comment in values.yaml for why this can't auto-generate
```

```bash
microk8s helm3 upgrade --install sidelab . -f values.mine.yaml \
  --namespace sidelab --create-namespace \
  --set image.repository=sidelab-launcher --set image.tag=latest \
  --set launcher.labImage=sidelab-app:v1
```

Confirms in the launcher logs as `📦 Database : MongoDB (sidelab)`. Both Pods (`sidelab` and `sidelab-mongodb`) should reach `1/1 Running`.

#### d. MongoDB — external (Atlas or self-hosted)

```yaml
database:
  backend: "mongo"
  mongo:
    url: "mongodb+srv://user:pass@cluster.mongodb.net/sidelab"
```

Or, to avoid putting a credential in a values file at all, create the Secret out of band first and reference it:

```bash
kubectl create secret generic sidelab-mongo -n sidelab \
  --from-literal=DB_URL='mongodb+srv://user:pass@cluster.mongodb.net/sidelab'
```

```yaml
database:
  backend: "mongo"
  mongo:
    existingSecret: "sidelab-mongo"
```

#### e. Ingress + Traefik + cert-manager + Let's Encrypt (production shape)

Needs a real cluster with Traefik and cert-manager installed — not exercisable on a bare MicroK8s node the way (b) is, but this is the intended production configuration, and worth keeping here as the known-valid reference:

```yaml
domain: "labs.example.com"
ingress:
  enabled: true
  className: "traefik"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
  tls:
    enabled: true
launcher:
  labAccess: "ingress"
database:
  backend: "mongo"
  mongo:
    url: "mongodb+srv://user:pass@cluster.mongodb.net/sidelab"
```

Dashboard: `https://sidelab.labs.example.com` (from the shared `domain`). Lab sessions: `https://<session-id>.labs.labs.example.com` — if that double `labs.` reads wrong for your naming, set `launcher.labDomain` explicitly instead of relying on the `domain` derivation (e.g. `launcher.labDomain: "labs.example.com"` directly, so sessions land on `<session-id>.labs.example.com`).

### 3. Check everything came up

```bash
kubectl get pod,svc,deploy,ingress,secret,pvc -n sidelab
```

### 4. Debug

Shell into the launcher:

```bash
kubectl exec -it -n sidelab deploy/sidelab -- sh
```

With the bundled MongoDB chart, forward its port to inspect data from Compass (`mongodb://root:<rootPassword>@localhost:27017/sidelab?authSource=admin`):

```bash
kubectl port-forward -n sidelab svc/sidelab-mongodb 27017:27017
```

### 5. Clean up

```bash
microk8s helm3 uninstall sidelab -n sidelab
kubectl delete namespace sidelab
```
