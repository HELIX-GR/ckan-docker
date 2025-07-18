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
# ckanext-hierarchy
ckanext.hierarchy.group_types=organization
# hdx
hdx.http_headers.routes=/country/topline/,/view/,/eaa-worldmap
hdx.http_headers.mimetypes=application/json,text/html,text/json
hdx.lunr.index_location=ckanext-hdx_theme/ckanext/hdx_theme/fanstatic/search_
# datacite
{{- include "hdx-ckan.configIniForDatacite" . }}
# oauth2
{{- include "hdx-ckan.configIniForOauth2" . }}
{{- end }}{{/* define */}}

{{- define "hdx-ckan.configIniForDatacite" }}
{{- with .Values.global.datacite }}
{{- $secret := lookup "v1" "Secret" $.Release.Namespace .auth.secretName }}
{{- $username := "" }}
{{- $password := "" }}
{{- if $secret }}
  {{- $username = (dig "data" "username" "" $secret) | b64dec }}
  {{- $password = (dig "data" "password" "" $secret) | b64dec }}
{{- end }}{{/* if $secret */}}
ckanext.hdx_package.datacite.prefix={{ .prefix }}
ckanext.hdx_package.datacite.api_url={{ .apiUrl }}
ckanext.hdx_package.datacite.client_id={{ $username }}
ckanext.hdx_package.datacite.password={{ $password }}
{{- end }}{{/* with .Values.global.datacite */}}
{{- end }}{{/* define */}}

{{- define "hdx-ckan.configIniForOauth2" }}
{{- with .Values.global.oauth2 }}
{{- $secret := lookup "v1" "Secret" $.Release.Namespace .client.secretName }}
{{- $clientId := "" }}
{{- $clientSecret := "" }}
{{- if $secret }}
  {{- $clientId = (dig "data" "client-id" "" $secret) | b64dec }}
  {{- $clientSecret = (dig "data" "client-secret" "" $secret) | b64dec }}
{{- end }}{{/* if $secret */}}
ckan.oauth2.authorization_endpoint={{ tpl .authorizationUrl .}}
ckan.oauth2.token_endpoint={{ tpl .tokenUrl . }}
ckan.oauth2.profile_api_url={{ tpl .userinfoUrl . }}
ckan.oauth2.client_id={{ $clientId }}
ckan.oauth2.client_secret={{ $clientSecret }}
ckan.oauth2.scope=openid profile email
ckan.oauth2.profile_api_user_field=email
ckan.oauth2.profile_api_fullname_field=name
ckan.oauth2.profile_api_mail_field=email
ckan.oauth2.authorization_header=Authorization
{{- end }}{{/* with .Values.global.oauth2 */}}
{{- end }}{{/* define */}}
