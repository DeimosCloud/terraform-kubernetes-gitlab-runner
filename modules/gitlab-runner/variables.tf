variable "namespace" {
  type    = string
  default = "gitlab-runner"
}

variable "service_account" {
  description = "The name of the Service account to create"
  type        = string
  default     = "gitlab-runner-admin"
}

variable "cluster_role" {
  description = "Cluster role for gitlab runner rbac"
  type        = string
  default     = "gitlab-runner-admin"
}

variable "cluster_role_binding" {
  description = "Cluster role for gitlab runner rbac"
  type        = string
  default     = "gitlab-runner-admin"
}

variable "runner_registration_token" {
  description = "runner registration token"
  type        = string
}

variable "runner_tags" {
  description = "runner tags"
  type        = string
}

variable "release_name" {
  description = "The helm release name"
  default     = "gitlab-runner"
}

variable "default_runner_image" {
  description = "Runner Tags"
  type        = string
}