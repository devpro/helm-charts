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
