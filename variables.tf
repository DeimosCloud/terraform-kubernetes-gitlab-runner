variable "namespace" {
  type    = string
  default = "gitlab-runner"
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "(Optional) Create the namespace if it does not yet exist. Defaults to false."
}

variable "service_account" {
  description = "The name of the Service account to create"
  type        = string
  default     = "gitlab-runner"
}

variable "service_account_annotations" {
  description = "The annotations to add to the service account"
  default     = {}
}

variable "chart_version" {
  description = "The version of the chart"
  default     = "0.28.0-rc1"
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
  description = "Specify the tags associated with the runner. Comma-separated list of tags."
  type        = string
}

variable "runner_locked" {
  description = "Specify whether the runner should be locked to a specific project/group"
  type        = string
  default     = true
}

variable "run_untagged_jobs" {
  description = "Specify if jobs without tags should be run. https://docs.gitlab.com/ce/ci/runners/#runner-is-allowed-to-run-untagged-jobs"
  default     = false
}

variable "release_name" {
  description = "The helm release name"
  default     = "gitlab-runner"
}

variable "default_runner_image" {
  description = "Runner Image"
  type        = string
  default     = null
}

variable "values_file" {
  description = "Path to Values file to be passed to gitlab-runner helm templates"
  default     = null
}

variable "gitlab_url" {
  description = "The GitLab Server URL (with protocol) that want to register the runner against"
  default     = "https://gitlab.com/"
}

variable "concurrent" {
  default     = 10
  description = "Configure the maximum number of concurrent jobs"
}

variable "rbac_enabled" {
  default     = true
  description = "For RBAC Support"
}

variable "use_local_cache" {
  default     = false
  description = "Use path on nodes for caching"
}

variable "local_cache_dir" {
  default     = "/tmp/gitlab/cache"
  description = "Path on nodes for caching"
}

variable "mount_docker_socket" {
  default     = false
  description = "Path on nodes for caching"
}

variable "build_dir" {
  default     = false
  description = "Path on nodes for caching"
}
