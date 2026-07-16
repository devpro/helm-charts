{{/*
Expand the name of the chart.
*/}}
{{- define "sidelab.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
Truncated to 63 chars because some Kubernetes name fields have this limit.
*/}}
{{- define "sidelab.fullname" -}}
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
{{- define "sidelab.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to all resources.
*/}}
{{- define "sidelab.labels" -}}
helm.sh/chart: {{ include "sidelab.chart" . }}
{{ include "sidelab.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels (used by Service and Deployment).
*/}}
{{- define "sidelab.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sidelab.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "sidelab.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sidelab.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the auth Secret (JWT_SECRET / ADMIN_USERNAME / ADMIN_PASSWORD keys).
*/}}
{{- define "sidelab.authSecretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- printf "%s-auth" (include "sidelab.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Name of the MongoDB connection Secret (DB_URL key).
*/}}
{{- define "sidelab.mongoSecretName" -}}
{{- if .Values.database.mongo.existingSecret }}
{{- .Values.database.mongo.existingSecret }}
{{- else }}
{{- printf "%s-mongo" (include "sidelab.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Ingress template ConfigMap name (for lab session Ingress resources).
*/}}
{{- define "sidelab.ingressTemplateConfigMap" -}}
{{- if .Values.launcher.ingressTemplateConfigMap }}
{{- .Values.launcher.ingressTemplateConfigMap }}
{{- else }}
{{- printf "%s-ingress-template" (include "sidelab.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Image tag — falls back to .Chart.AppVersion.
*/}}
{{- define "sidelab.imageTag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Dashboard hostname. ingress.host wins; otherwise derived from the shared top-level `domain` value as "sidelab.<domain>".
Empty if neither is set.
*/}}
{{- define "sidelab.ingressHost" -}}
{{- if .Values.ingress.host -}}
{{- .Values.ingress.host -}}
{{- else if .Values.domain -}}
{{- printf "sidelab.%s" .Values.domain -}}
{{- end -}}
{{- end }}

{{/*
Lab session wildcard domain. launcher.labDomain wins; otherwise derived from the shared top-level `domain` value as "labs.<domain>".
Empty if neither is set.
*/}}
{{- define "sidelab.labDomain" -}}
{{- if .Values.launcher.labDomain -}}
{{- .Values.launcher.labDomain -}}
{{- else if .Values.domain -}}
{{- printf "labs.%s" .Values.domain -}}
{{- end -}}
{{- end }}

{{/*
MongoDB connection string.
database.mongo.url wins;
otherwise, if the bundled mongodb subchart is enabled, derived from its default standalone Service name
("<release-name>-mongodb", per the alias in Chart.yaml and the Bitnami chart's own naming convention) and mongodb.auth.rootPassword.
Only called from secret.yaml when database.mongo.existingSecret is not set.
*/}}
{{- define "sidelab.mongoUrl" -}}
{{- if .Values.database.mongo.url -}}
{{- .Values.database.mongo.url -}}
{{- else if .Values.mongodb.enabled -}}
{{- printf "mongodb://root:%s@%s-mongodb:27017/sidelab?authSource=admin" .Values.mongodb.auth.rootPassword .Release.Name -}}
{{- end -}}
{{- end }}

{{/*
JWT secret — auth.jwtSecret wins; otherwise reused from the existing Secret on upgrade (via lookup), or freshly generated on first install.
`lookup` returns nothing outside a real cluster (e.g. `helm template`), so offline rendering always generates a fresh value —
expected, and harmless for a dry render.
Only called from secret.yaml when auth.existingSecret is not set.
*/}}
{{- define "sidelab.jwtSecret" -}}
{{- if .Values.auth.jwtSecret -}}
{{- .Values.auth.jwtSecret -}}
{{- else -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (include "sidelab.authSecretName" .) -}}
{{- if and $existing $existing.data (hasKey $existing.data "JWT_SECRET") -}}
{{- index $existing.data "JWT_SECRET" | b64dec -}}
{{- else -}}
{{- randAlphaNum 48 -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Admin password — same reuse-then-generate pattern as sidelab.jwtSecret above.
Only called from secret.yaml when auth.existingSecret is not set.
*/}}
{{- define "sidelab.adminPassword" -}}
{{- if .Values.auth.adminPassword -}}
{{- .Values.auth.adminPassword -}}
{{- else -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (include "sidelab.authSecretName" .) -}}
{{- if and $existing $existing.data (hasKey $existing.data "ADMIN_PASSWORD") -}}
{{- index $existing.data "ADMIN_PASSWORD" | b64dec -}}
{{- else -}}
{{- randAlphaNum 20 -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Validate required values and emit a clear error message.
*/}}
{{- define "sidelab.validateValues" -}}
{{- if not .Values.image.repository }}
{{- fail "image.repository is required." }}
{{- end }}
{{- if and (eq .Values.database.backend "mongo") (not .Values.database.mongo.url) (not .Values.database.mongo.existingSecret) (not .Values.mongodb.enabled) }}
{{- fail "database.backend=mongo needs one of: database.mongo.url, database.mongo.existingSecret, or mongodb.enabled=true." }}
{{- end }}
{{- if and .Values.mongodb.enabled (not .Values.database.mongo.url) (not .Values.database.mongo.existingSecret) (not .Values.mongodb.auth.rootPassword) }}
{{- fail "mongodb.auth.rootPassword is required when mongodb.enabled=true (unless database.mongo.url or database.mongo.existingSecret is set instead)." }}
{{- end }}
{{- if and .Values.ingress.enabled (not (include "sidelab.ingressHost" .)) }}
{{- fail "ingress.host or domain is required when ingress.enabled=true." }}
{{- end }}
{{- if and (eq .Values.launcher.labAccess "ingress") (not (include "sidelab.labDomain" .)) }}
{{- fail "launcher.labDomain or domain is required when launcher.labAccess=ingress." }}
{{- end }}
{{- end }}
