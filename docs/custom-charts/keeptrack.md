# Keeptrack

Let's see how to deploy [Keeptrack](https://github.com/devpro/keeptrack) on a Kubernetes cluster.

## Repository

Make sure to have the **devpro** Helm repository:

```bash
helm repo add devpro https://devpro.github.io/helm-charts
helm repo update
```

## Homelab setup example

In a k3s cluster with **no ingress controller**, we have:

- [Flux](https://fluxcd.io) managing everything from Git,
- secrets encrypted with [SOPS](https://github.com/getsops/sops),
- a [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/),
- a [MongoDB Atlas](https://www.mongodb.com/atlas) cluster provisioned and configured (database user, IP restriction list).

### Nothing to expose through the tunnel except the Blazor app

The browser reaches `BlazorApp` (Blazor **Server**), which itself calls the Web API, from inside the cluster, over the plain `ClusterIP` Service the chart already creates (`http://keeptrack-webapi`).

Only one **Public Hostname** needs adding in the Cloudflare Zero Trust dashboard:

Field              | Value
-------------------|-----------------------------------------------------
Subdomain / domain | `keeptrack` / your domain
Service type       | `HTTP`
URL                | `keeptrack-blazorapp.keeptrack.svc.cluster.local:80`

> [!IMPORTANT]
> No Kubernetes `Ingress` object, ingress controller, or TLS certificate is needed anywhere in the cluster -
> Cloudflare terminates TLS at its edge and the tunnel forwards plain HTTP to the Service.

### Secrets, encrypted with SOPS

> [!NOTE]
> Keeptrack needs two kinds of secrets regardless of this specific setup: Firebase (authentication is mandatory) and the Mongo connection string.
> Reference-data provider keys (TMDB/RAWG/Discogs) are optional - enrichment for that provider silently no-ops without one.

1. Write the plain manifest in the Flux-managed Git repository:

    ```yaml
    # clusters/homelab/keeptrack/secret.keeptrack.yaml (before encryption)
    apiVersion: v1
    kind: Secret
    metadata:
      name: keeptrack-app
      namespace: keeptrack
    stringData:
      connectionString: "mongodb+srv://keeptrack:<password>@<cluster>.mongodb.net/keeptrack?retryWrites=true&w=majority"
      firebaseApiKey: "***"
      firebaseAuthDomain: "***"
      firebaseProjectId: "***"
      firebaseAuthority: "https://securetoken.google.com/<project-id>"
      firebaseServiceAccount: |
        {"type": "service_account", "project_id": "...", "private_key": "...", ...}
      tmdbApiKey: "***"
      rawgApiKey: "***"
      discogsToken: "***"
    ```

2. Encrypt it in place before committing:

    ```bash
    sops --encrypt --in-place clusters/homelab/keeptrack/secret.keeptrack.yaml
    ```

3. Commit the encrypted file.

### HelmRelease

```yaml
# clusters/homelab/keeptrack/helmrepository.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: devpro
  namespace: keeptrack
spec:
  interval: 1h
  url: https://devpro.github.io/helm-charts
---
# clusters/homelab/keeptrack/helmrelease.yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: keeptrack
  namespace: keeptrack
spec:
  interval: 30m
  chart:
    spec:
      chart: keeptrack
      version: "0.2.x"
      sourceRef:
        kind: HelmRepository
        name: devpro
  values:
    blazorapp:
      host: keeptrack.example.com

    webapi:
      db:
        connectionStringSecretKeyRef:
          name: keeptrack-app
          key: connectionString
        databaseName: keeptrack
      referenceData:
        tmdb:
          apiKeySecretKeyRef: { name: keeptrack-app, key: tmdbApiKey }
        rawg:
          apiKeySecretKeyRef: { name: keeptrack-app, key: rawgApiKey }
        discogs:
          tokenSecretKeyRef: { name: keeptrack-app, key: discogsToken }

    firebase:
      auth:
        authoritySecretKeyRef: { name: keeptrack-app, key: firebaseAuthority }
      webApp:
        apiKeySecretKeyRef: { name: keeptrack-app, key: firebaseApiKey }
        authDomainSecretKeyRef: { name: keeptrack-app, key: firebaseAuthDomain }
        projectIdSecretKeyRef: { name: keeptrack-app, key: firebaseProjectId }
      serviceAccountSecretKeyRef: { name: keeptrack-app, key: firebaseServiceAccount }

    mongodb:
      enabled: false

    ingress:
      enabled: false
```

### Verify

```bash
flux get helmrelease keeptrack -n keeptrack
kubectl get pods -n keeptrack
```

Open `https://keeptrack.example.com` (the tunnel's hostname).

Add the same hostname to Firebase's authorized domains (Authentication > Settings) - Firebase rejects sign-in from an unlisted domain regardless of what the tunnel or ingress does.

Grant the first admin user (there's no in-app way to do this): a one-off Firebase Admin SDK `setCustomUserClaims({ role: "admin" })` call.
