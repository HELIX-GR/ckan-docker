{{/* vim: set syntax=helm: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "hdx-ckan.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hdx-ckan.fullname" -}}
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
{{- define "hdx-ckan.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hdx-ckan.labels" -}}
helm.sh/chart: {{ include "hdx-ckan.chart" . }}
{{ include "hdx-ckan.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hdx-ckan.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hdx-ckan.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hdx-ckan.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hdx-ckan.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* 
  Redefine named templates from "ckan" subchart
*/}}

{{- define "ckan.configIniOverrideForBase" -}}
ckan.search.show_all_types=dataset
ckan.search.solr_allowed_query_parsers=bool knn
{{- end }}{{/* define */}}

{{- define "ckan.configIniForExtensions" -}}
ckanext.hierarchy.group_types=organization
hdx.http_headers.routes=/country/topline/,/view/,/eaa-worldmap
hdx.http_headers.mimetypes=application/json,text/html,text/json
hdx.lunr.index_location=ckanext-hdx_theme/ckanext/hdx_theme/fanstatic/search_
{{- end }}{{/* define */}}

