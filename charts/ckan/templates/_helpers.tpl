{{/* vim: set syntax=helm: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "ckan.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ckan.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "ckan.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ckan.labels" -}}
helm.sh/chart: {{ include "ckan.chart" . }}
{{ include "ckan.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ckan.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ckan.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "ckan.envFrom" -}}
- secretRef:
    name: {{ printf "%s-env-generated" (include "ckan.fullname" .) }}
{{- with .Values.extraEnv }}
{{- if .configMapName }}
- configMapRef:
    name: {{ .configMapName }}
{{- else if .secretName }}
- secretRef:
    name: {{ .secretName }}
{{- end }}{{/* if .configMapName */}}
{{- end }}{{/* with .Values.extraEnv */}}
{{- end }}{{/* ckan.extraEnvFrom */}}

