# vim: set syntax=hcl:

variable "ckan_tag" {
  default = "ckan-2.10.8"
}

variable "hdx_ckan_tag" {
  # https://github.com/HELIX-GR/hdx-ckan/
  default = "heallink-0.1e"
}

variable "ckanext_oauth2_tag" {
  # https://github.com/HELIX-GR/ckanext-oauth2
  default = "heallink-0.1f"
}

variable hdx_ckan_image_tag {
  default = regex_replace("${hdx_ckan_tag}", "heallink-([0-9]+([.][0-9]+){1,2})([a-z])?$", "$1")
}

target "base-builder" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
  }
  dockerfile = "base-builder.dockerfile"
  tags = []
}

target "builder" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
    hdx_ckan_tag="${hdx_ckan_tag}"
    ckanext_oauth2_tag="${ckanext_oauth2_tag}"
  }
  dockerfile = "builder.dockerfile"
  contexts = {
    "base-builder" = "target:base-builder"
  }
  tags = []
}

target "runtime" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
    hdx_ckan_tag="${hdx_ckan_tag}"
  }
  dockerfile = "runtime.dockerfile"
  contexts = {
    "builder" = "target:builder"
  }
  tags = [
    "ghcr.io/helix-gr/hdx-ckan:${hdx_ckan_image_tag}-${ckan_tag}"
  ]
}

target "gunicorn-server" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
    hdx_ckan_tag="${hdx_ckan_tag}"
  }
  dockerfile = "run-with-gunicorn.dockerfile"
  contexts = {
    "runtime" = "target:runtime" 
  }
  tags = [
    "ghcr.io/helix-gr/hdx-ckan:${hdx_ckan_image_tag}-${ckan_tag}-gunicorn"
  ]
}

target "simple-server" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
    hdx_ckan_tag="${hdx_ckan_tag}"
  }
  dockerfile = "run-with-simple-server.dockerfile"
  contexts = {
    "runtime" = "target:runtime" 
  }
  tags = [
    "ghcr.io/helix-gr/hdx-ckan:${hdx_ckan_image_tag}-${ckan_tag}-simple-server"
  ]
}

target "dev" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
  }
  dockerfile = "run-with-simple-server-dev.dockerfile"
  contexts = {
    "runtime" = "target:runtime" 
  }
  tags = [
    "ghcr.io/helix-gr/hdx-ckan:${hdx_ckan_image_tag}-${ckan_tag}-dev"
  ]
}

group "default" {
  targets = [
    "gunicorn-server",
    "simple-server",
    "dev"
  ]
}
