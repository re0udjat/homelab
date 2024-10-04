{{/*
Define the name of the Chart.
*/}}
{{- define "cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define a default fully qualified app name.
We truncate at 63 chars because some K8s name fields are limited to this (DNS naming spec).
If release name contains chart name, it will be used as a full name.
*/}}
{{- define "cluster.fullname" -}}
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
Create Chart name and version as used by the Chart label.
*/}}
{{- define "cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: cloudnative-pg
{{- end }}

{{/*
Common labels
*/}}
{{- define "cluster.labels" -}}
helm.sh/chart: {{ include "cluster.chart" . }}
{{ include "cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
The Postgresql major version 
*/}}
{{- define "cluster.postgresqlMajor" -}}
{{ index (regexSplit "\\." (toString .Values.version.postgresql) 2) 0 }}
{{- end }}

{{/*
Cluster image name
*/}}
{{- define "cluster.imageName" }}
  {{- if .Values.cluster.imageName }}
    {{- .Values.cluster.imageName }}
  {{- else if eq .Values.type "postgresql" }}
    {{- printf "ghcr.io/cloudnative-pg/postgresql:%s" .Values.version.postgresql }}
  {{- else }}
    {{ fail "Invalid Cluster Type!"}}
  {{- end }}
{{- end }}

{{/*
Cluster image
Use imageCatalogRef if it is defined, otherwise calculate ordinary imageName.
*/}}
{{- define "cluster.image" -}}
{{- if .Values.cluster.imageCatalogRef }}
imageCatalogRef:
  apiGroup: postgresql.cnpg.io
  {{- toYaml .Values.cluster.imageCatalogRef | nindent 2 }}
  major: {{ include "cluster.postgresqlMajor" . }}
{{- else if and .Values.imageCatalog.create (not (empty .Values.imageCatalog.images)) }}
imageCatalogRef:
  apiGroup: postgresql.cnpg.io
  kind: ImageCatalog
  name: {{ include "cluster.fullname" . }}
  major: {{ include "cluster.postgresqlMajor" . }}
{{- else }}
imageName: {{ include "cluster.imageName" . }}
{{- end }}
{{- end }}