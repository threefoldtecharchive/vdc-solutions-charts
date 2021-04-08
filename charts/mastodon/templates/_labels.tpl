{{/* vim: set filetype=mustache: */}}
{{/*
Kubernetes standard labels
*/}}
{{- define "common.labels.standard" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}