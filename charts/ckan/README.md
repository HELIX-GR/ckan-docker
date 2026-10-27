# README

## 1. Extension points for dependent charts

In a dependent chart (for a more custom-made CKAN deployment), you can override (re-define) the following named templates:

 - ckan.configIniOverrideForBase
 - ckan.configIniForExtensions

 An example:

 ```helm
{{- define "ckan.configIniOverrideForBase" -}}
ckan.search.show_all_types=dataset
ckan.search.solr_allowed_query_parsers=bool knn
{{- end }}{{/* define */}}

{{- define "ckan.configIniForExtensions" -}}
foo_dir=path/to/somewhere
ckanext.foo.bar=Bar
ckanext.foo.theme_location=%(foo_dir)s/theme
{{- end }}{{/* define */}}

 ```


