# vim: set syntax=hcl:

variable "ckan_tag" {
  default = "ckan-2.10.8"
}

target "base-builder" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
  }
  dockerfile = "base-builder.dockerfile"
  tags = []
}

target "runtime" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
  }
  dockerfile = "runtime.dockerfile"
  contexts = {
    "builder" = "target:base-builder" 
  }
  tags = [
    "ghcr.io/helix-gr/ckan-base:${ckan_tag}"
  ]
}

target "gunicorn-server" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
  }
  dockerfile = "run-with-gunicorn.dockerfile"
  contexts = {
    "runtime" = "target:runtime" 
  }
  tags = [
    "ghcr.io/helix-gr/ckan-base:${ckan_tag}-gunicorn"
  ]
}

target "simple-server" {
  context = "."
  args = {
    ckan_tag="${ckan_tag}"
  }
  dockerfile = "run-with-simple-server.dockerfile"
  contexts = {
    "runtime" = "target:runtime" 
  }
  tags = [
    "ghcr.io/helix-gr/ckan-base:${ckan_tag}-simple-server"
  ]
}

group "default" {
  targets = [
    "gunicorn-server"
  ]
}
