variable "namespace" {
  type    = string
  default = "gitlab-runner"
}

variable "runner_image_tag" {
  description = "The docker gitlab runner version. https://hub.docker.com/r/gitlab/gitlab-runner/tags/"
  default     = "alpine-v13.11.0-rc1"
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

variable "image_pull_secret" {
  description = "The name of the Image Pull Secret to use"
  type        = string
  default     = null
}

variable "tolerations" {
  description = "Tolerations for the gitlab"
  default = {
    key      = "gitlab-runner"
    operator = "Equal"
    value    = true
    effect   = "NO_EXECUTE"
  }
}


variable "service_account_annotations" {
  description = "The annotations to add to the service account"
  default     = {}
}

variable "service_account_clusterwide_access" {
  description = "Run the gitlab-bastion container with the ability to deploy/manage containers of jobs cluster-wide or only within namespace"
  default     = false
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

variable "default_container_image" {
  description = "Default container image to use for builds when none is specified"
  type        = string
  default     = "ubuntu:18.04"
}

variable "values_file" {
  description = "Path to Values file to be passed to gitlab-runner helm templates"
  default     = null
}

variable "gitlab_url" {
  description = "The GitLab Server URL (with protocol) that want to register the runner against"
  default     = "https://gitlab.patriciadev.com/"
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
  type        = bool
}

variable "build_dir" {
  default     = null
  type        = string
  description = "Path on nodes for caching"
}

variable "run_container_as_user" {
  default     = null
  type        = string
  description = "SecurityContext: runAsUser for all running job pods"
}

variable "priviledged" {
  default     = false
  type        = bool
  description = "Run all containers with the privileged flag enabled. This will allow the docker:dind image to run if you need to run Docker"
}

variable "docker_fs_group" {
  description = "The fsGroup to use for docker. This is added to security context when mount_docker_socket is enabled"
  default     = 412
}
