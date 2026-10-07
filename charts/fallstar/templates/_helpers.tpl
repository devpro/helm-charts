{{- define "fallstar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "fallstar.fullname" -}}
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

{{- define "fallstar.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "fallstar.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "fallstar.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fallstar.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "fallstar.authSecretName" -}}
{{- default (printf "%s-auth" (include "fallstar.fullname" .)) .Values.auth.existingSecret }}
{{- end }}

{{- define "fallstar.mongoSecretName" -}}
{{- default (printf "%s-mongo" (include "fallstar.fullname" .)) .Values.database.mongo.existingSecret }}
{{- end }}

{{/*
A generated value is read back from the existing Secret on upgrade, so the master secret never changes by itself.
`lookup` returns nothing outside a cluster, so `helm template` generates a fresh one.
*/}}
{{- define "fallstar.generated" -}}
{{- $existing := lookup "v1" "Secret" .root.Release.Namespace (include "fallstar.authSecretName" .root) -}}
{{- if and $existing $existing.data (hasKey $existing.data .key) -}}
{{- index $existing.data .key | b64dec -}}
{{- else -}}
{{- randAlphaNum .length -}}
{{- end -}}
{{- end }}

{{/*
Whether the configuration holds state only one Pod may own: a SQLite file, or a ReadWriteOnce volume.
Returns "true" or "" (empty is false in an `if`).
*/}}
{{- define "fallstar.singleWriter" -}}
{{- if or (eq .Values.database.backend "sqlite") .Values.persistence.enabled -}}
true
{{- end -}}
{{- end }}

{{/*
Highest number of Pods this release can run, autoscaling included.
*/}}
{{- define "fallstar.maxReplicas" -}}
{{- if .Values.autoscaling.enabled -}}
{{- max (.Values.replicaCount | int) (.Values.autoscaling.maxReplicas | int) -}}
{{- else -}}
{{- .Values.replicaCount | int -}}
{{- end -}}
{{- end }}

{{- define "fallstar.validateValues" -}}
{{- if not .Values.image.repository }}
{{- fail "image.repository is required." }}
{{- end }}
{{- if and (eq .Values.database.backend "mongo") (not .Values.database.mongo.url) (not .Values.database.mongo.existingSecret) }}
{{- fail "database.backend=mongo needs database.mongo.url or database.mongo.existingSecret." }}
{{- end }}
{{- if and .Values.auth.secret (lt (len .Values.auth.secret) 32) }}
{{- fail "auth.secret needs at least 32 characters." }}
{{- end }}
{{- if and (gt (int (include "fallstar.maxReplicas" .)) 1) (include "fallstar.singleWriter" .) }}
{{- fail "More than one replica requires database.backend=mongo and persistence.enabled=false: SQLite is a local file, and a ReadWriteOnce volume cannot be mounted by two Pods." }}
{{- end }}
{{- if and .Values.autoscaling.enabled (not .Values.resources.requests) }}
{{- fail "autoscaling.enabled needs resources.requests.cpu, the target being a share of it." }}
{{- end }}
{{- if and .Values.ingress.enabled (not .Values.ingress.host) }}
{{- fail "ingress.host is required when ingress.enabled=true." }}
{{- end }}
{{- end }}
