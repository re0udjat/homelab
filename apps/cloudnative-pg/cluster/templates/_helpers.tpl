{{/*
Create a default fully qualified app name.
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
Get the PostgreSQL major version
*/}}
{{- define "cluster.postgresqlMajor" }}
{{- index (regexSplit "\\." (toString .Values.version.postgresql) 2) 0 }}
{{- end -}}

{{/*
Pod's image name
*/}}
{{- define "cluster.imageName" -}}
{{- if .Values.cluster.imageName }}
{{- .Values.cluster.imageName }}
{{- else if eq .Values.type "postgresql" }}
{{- printf "ghcr.io/cloudnative-pg/postgresql:%s" .Values.version.postgresql }}
{{- else }}
{{ fail "Invalid Cluster type!" }}
{{- end }}
{{- end }}

{{/*
Pod's image definition
*/}}
{{- define "cluster.image" }}
{{- if .Values.cluster.imageCatalogRef.name }}
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