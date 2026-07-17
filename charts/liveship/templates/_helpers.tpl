{{/*
Expand the name of the chart.
*/}}
{{- define "liveship.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
Truncated to 63 chars because some Kubernetes name fields have this limit.
*/}}
{{- define "liveship.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart label value (name + version).
*/}}
{{- define "liveship.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to all resources.
*/}}
{{- define "liveship.labels" -}}
helm.sh/chart: {{ include "liveship.chart" . }}
{{ include "liveship.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels (used by Service and Deployment).
*/}}
{{- define "liveship.selectorLabels" -}}
app.kubernetes.io/name: {{ include "liveship.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "liveship.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "liveship.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the auth Secret (NEXTAUTH_SECRET / ENCRYPTION_KEY keys).
*/}}
{{- define "liveship.authSecretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- printf "%s-auth" (include "liveship.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Name of the MongoDB connection Secret (MONGODB_URI key).
*/}}
{{- define "liveship.mongoSecretName" -}}
{{- if .Values.database.existingSecret }}
{{- .Values.database.existingSecret }}
{{- else }}
{{- printf "%s-mongo" (include "liveship.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Image tag — falls back to .Chart.AppVersion.
*/}}
{{- define "liveship.imageTag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
External URL of the app (NEXTAUTH_URL). auth.url wins; otherwise derived from
the ingress host and TLS setting; otherwise localhost:3000, which matches the
kubectl port-forward instructions in NOTES.txt (NextAuth builds every
login/callback redirect from this value, so it has to be what the browser uses).
*/}}
{{- define "liveship.nextauthUrl" -}}
{{- if .Values.auth.url -}}
{{- .Values.auth.url -}}
{{- else if and .Values.ingress.enabled .Values.ingress.host -}}
{{- printf "http%s://%s" (ternary "s" "" .Values.ingress.tls.enabled) .Values.ingress.host -}}
{{- else -}}
http://localhost:3000
{{- end -}}
{{- end }}

{{/*
MongoDB connection string.
database.uri wins;
otherwise, if the bundled mongodb subchart is enabled, derived from its default standalone Service name
("<release-name>-mongodb", per the alias in Chart.yaml and the Bitnami chart's own naming convention) and mongodb.auth.rootPassword.
The database itself is selected by MONGODB_DB (database.name), not the URI path.
Only called from secret.yaml when database.existingSecret is not set.
*/}}
{{- define "liveship.mongoUri" -}}
{{- if .Values.database.uri -}}
{{- .Values.database.uri -}}
{{- else if .Values.mongodb.enabled -}}
{{- printf "mongodb://root:%s@%s-mongodb:27017/?authSource=admin" .Values.mongodb.auth.rootPassword .Release.Name -}}
{{- end -}}
{{- end }}

{{/*
NextAuth secret — auth.nextauthSecret wins; otherwise reused from the existing Secret on upgrade (via lookup), or freshly generated on first install.
`lookup` returns nothing outside a real cluster (e.g. `helm template`), so offline rendering always generates a fresh value —
expected, and harmless for a dry render.
Only called from secret.yaml when auth.existingSecret is not set.
*/}}
{{- define "liveship.nextauthSecret" -}}
{{- if .Values.auth.nextauthSecret -}}
{{- .Values.auth.nextauthSecret -}}
{{- else -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (include "liveship.authSecretName" .) -}}
{{- if and $existing $existing.data (hasKey $existing.data "NEXTAUTH_SECRET") -}}
{{- index $existing.data "NEXTAUTH_SECRET" | b64dec -}}
{{- else -}}
{{- randAlphaNum 48 -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Encryption key — same reuse-then-generate pattern as liveship.nextauthSecret above,
except the generated value must be exactly 64 hex characters (the app enforces
a 32-byte hex key): sha256sum of a random string gives exactly that.
Only called from secret.yaml when auth.existingSecret is not set.
*/}}
{{- define "liveship.encryptionKey" -}}
{{- if .Values.auth.encryptionKey -}}
{{- .Values.auth.encryptionKey -}}
{{- else -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (include "liveship.authSecretName" .) -}}
{{- if and $existing $existing.data (hasKey $existing.data "ENCRYPTION_KEY") -}}
{{- index $existing.data "ENCRYPTION_KEY" | b64dec -}}
{{- else -}}
{{- randAlphaNum 64 | sha256sum -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Validate required values and emit a clear error message.
*/}}
{{- define "liveship.validateValues" -}}
{{- if not .Values.image.repository }}
{{- fail "image.repository is required." }}
{{- end }}
{{- if and (not .Values.database.uri) (not .Values.database.existingSecret) (not .Values.mongodb.enabled) }}
{{- fail "A MongoDB is required: set one of database.uri, database.existingSecret, or mongodb.enabled=true." }}
{{- end }}
{{- if and .Values.mongodb.enabled (not .Values.database.uri) (not .Values.database.existingSecret) (not .Values.mongodb.auth.rootPassword) }}
{{- fail "mongodb.auth.rootPassword is required when mongodb.enabled=true (unless database.uri or database.existingSecret is set instead)." }}
{{- end }}
{{- if and .Values.ingress.enabled (not .Values.ingress.host) }}
{{- fail "ingress.host is required when ingress.enabled=true." }}
{{- end }}
{{- if and .Values.auth.encryptionKey (not (regexMatch "^[0-9a-fA-F]{64}$" .Values.auth.encryptionKey)) }}
{{- fail "auth.encryptionKey must be exactly 64 hex characters (openssl rand -hex 32) — the app refuses any other shape at startup." }}
{{- end }}
{{- end }}
