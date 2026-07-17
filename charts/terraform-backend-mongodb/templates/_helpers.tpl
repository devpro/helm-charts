{{/*
Recommended Kubernetes labels (https://helm.sh/docs/chart_best_practices/labels/), added on top of
the app-specific `app` / `app.kubernetes.io/name` labels every template already sets directly.
These are informational only - never add them to a Deployment's spec.selector.matchLabels, which
is immutable and would break `helm upgrade` for existing releases.
Call with a dict: (dict "app" . "root" $) where "." is the current webapi values entry.
*/}}
{{- define "terraform-backend-mongodb.commonLabels" -}}
helm.sh/chart: {{ printf "%s-%s" .root.Chart.Name .root.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/part-of: terraform-backend-mongodb
{{- if .app.role }}
app.kubernetes.io/component: {{ .app.role }}
{{- end }}
{{- end -}}

{{/*
Fully-qualified resource name for an application entry (webapi). Prefixes the app's own `.name`
(e.g. "tfbackend") with the release name, unless `.name` already contains it - so two releases in the
same namespace that both leave `.name` at its default don't collide on Deployment/Service/Ingress/
ServiceAccount names (or on their selector labels, which use the same value).
Call with a dict: (dict "app" . "root" $) where "." is the current webapi values entry.
*/}}
{{- define "terraform-backend-mongodb.fullname" -}}
{{- if contains .app.name .root.Release.Name -}}
{{- .root.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .root.Release.Name .app.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
MongoDB connection string.
webapi.db.connectionString wins; otherwise, if the bundled mongodb subchart is enabled, derived from
its default standalone Service name ("<release-name>-mongodb", per the alias in Chart.yaml and the
Bitnami chart's own naming convention) and mongodb.auth.rootPassword.
Only called from secret.yaml when webapi.db.connectionStringSecretKeyRef is not set.
*/}}
{{- define "terraform-backend-mongodb.mongoConnectionString" -}}
{{- if .Values.webapi.db.connectionString -}}
{{- .Values.webapi.db.connectionString -}}
{{- else if .Values.mongodb.enabled -}}
{{- printf "mongodb://root:%s@%s-mongodb:27017/?authSource=admin" .Values.mongodb.auth.rootPassword .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Validate required values and emit a clear error message instead of silently rendering a placeholder
or a broken manifest.
*/}}
{{- define "terraform-backend-mongodb.validateValues" -}}
{{- if .Values.webapi.enabled }}
{{- if and (not .Values.webapi.db.connectionString) (not .Values.webapi.db.connectionStringSecretKeyRef) (not .Values.mongodb.enabled) }}
{{- fail "A MongoDB connection is required: set webapi.db.connectionString, webapi.db.connectionStringSecretKeyRef, or mongodb.enabled=true." }}
{{- end }}
{{- if and .Values.mongodb.enabled (not .Values.webapi.db.connectionString) (not .Values.webapi.db.connectionStringSecretKeyRef) (not .Values.mongodb.auth.rootPassword) }}
{{- fail "mongodb.auth.rootPassword is required when mongodb.enabled=true (unless webapi.db.connectionString or webapi.db.connectionStringSecretKeyRef is set instead)." }}
{{- end }}
{{- if and .Values.ingress.enabled (not .Values.webapi.host) }}
{{- fail "webapi.host is required when ingress.enabled=true." }}
{{- end }}
{{- end }}
{{- end -}}
