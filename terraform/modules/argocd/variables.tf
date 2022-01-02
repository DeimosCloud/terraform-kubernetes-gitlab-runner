variable "namespace" {
  default     = "argocd"
  description = "The namespace to deploy argocd into"
}

variable "repositories" {
  description = "A list of repository defintions"
  default     = []
  type        = list(map(string))
}

variable "chart_version" {
  description = "version of charts"
  default     = "2.11.2"
}

variable "server_extra_args" {
  description = "Extra arguments passed to argoCD server"
  default     = []
}

variable "server_insecure" {
  description = "Whether to run the argocd-server with --insecure flag. Useful when disabling argocd-server tls default protocols to provide your certificates"
  default     = false
}

variable "ingress_tls_secret" {
  description = "The TLS secret name for argocd ingress"
  default     = "argocd-tls"
}

variable "ingress_host" {
  description = "The ingress host"
  default     = null
}

variable "ingress_annotations" {
  description = "annotations to pass to the ingress"
  default     = {}
}

variable "manifests" {
  description = "Path/URL to manifests to be applied after argocd is deployed"
  default     = null
  type        = list(string)
}

variable "image_tag" {
  description = "Image tag to install"
  default     = "v1.8.0-rc2"
  type        = string
}
