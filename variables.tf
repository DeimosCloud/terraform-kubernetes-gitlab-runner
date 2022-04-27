variable "namespace" {
  type    = string
  default = "gitlab-runner"
}

variable "runner_image" {
  description = "The docker gitlab runner version. https://hub.docker.com/r/gitlab/gitlab-runner/tags/"
  default     = null
  type        = string
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

variable "service_account_clusterwide_access" {
  description = "Run the gitlab-bastion container with the ability to deploy/manage containers of jobs cluster-wide or only within namespace"
  default     = false
}

variable "chart_version" {
  description = "The version of the chart"
  default     = "0.36.0"
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

variable "build_job_default_container_image" {
  description = "Default container image to use for builds when none is specified"
  type        = string
  default     = "ubuntu:18.04"
}

variable "values_file" {
  description = "Path to Values file to be passed to gitlab-runner helm chart"
  default     = null
  type        = string
}

variable "values" {
  description = "Additional values to be passed to the gitlab-runner helm chart"
  default     = {}
}

variable "gitlab_url" {
  description = "The GitLab Server URL (with protocol) that want to register the runner against"
  default     = "https://gitlab.com/"
}

variable "concurrent" {
  default     = 10
  description = "Configure the maximum number of concurrent jobs"
}

variable "create_service_account" {
  default     = true
  description = "If true, the service account, it's role and rolebinding will be created, else, the service account is assumed to already be created"
}

variable "use_local_cache" {
  default     = false
  description = "Use path on nodes for caching"
}

variable "local_cache_dir" {
  default     = "/tmp/gitlab/cache"
  description = "Path on nodes for caching"
}

variable "build_job_mount_docker_socket" {
  default     = false
  description = "Path on nodes for caching"
  type        = bool
}

variable "build_dir" {
  default     = null
  type        = string
  description = "Path on nodes for caching"
}

variable "build_job_run_container_as_user" {
  default     = null
  type        = string
  description = "SecurityContext: runAsUser for all running job pods"
}

variable "build_job_privileged" {
  default     = false
  type        = bool
  description = "Run all containers with the privileged flag enabled. This will allow the docker:dind image to run if you need to run Docker"
}

variable "docker_fs_group" {
  description = "The fsGroup to use for docker. This is added to security context when mount_docker_socket is enabled"
  default     = 412
}

variable "build_job_node_selectors" {
  description = "A map of node selectors to apply to the pods"
  default     = {}
}

variable "build_job_node_tolerations" {
  description = "A map of node tolerations to apply to the pods as defined https://docs.gitlab.com/runner/executors/kubernetes.html#other-configtoml-settings"
  default     = {}
}

variable "build_job_pod_labels" {
  description = "A map of labels to be added to each build pod created by the runner. The value of these can include environment variables for expansion. "
  default     = {}
}

variable "build_job_pod_annotations" {
  description = "A map of annotations to be added to each build pod created by the Runner. The value of these can include environment variables for expansion. Pod annotations can be overwritten in each build. "
  default     = {}
}


variable "cache_type" {
  description = "One of: s3, gcs, azure. Only used when var.use_local_cache is false"
  default     = null
  type        = string
}

variable "cache_path" {
  description = "Name of the path to prepend to the cache URL. Only used when var.use_local_cache is false"
  default     = null
  type        = string
}

variable "cache_shared" {
  description = "Enables cache sharing between runners. Only used when var.use_local_cache is false"
  default     = false
}

variable "azure_cache_conf" {
  description = "Cache parameters define using Azure Blob Storage for caching as seen https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscacheazure-section. Only used when var.use_local_cache is false"
  default     = {}
}

variable "gcs_cache_conf" {
  description = "Cache parameters define using Azure Blob Storage for caching as seen https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscachegcs-section. Only used when var.use_local_cache is false"
  default     = {}
}

variable "s3_cache_conf" {
  description = "Cache parameters define using S3 for caching as seen https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscaches3-section. Only used when var.use_local_cache is false"
  default     = {}
}

variable "build_job_secret_volumes" {
  description = "Secret volume configuration instructs Kubernetes to use a secret that is defined in Kubernetes cluster and mount it inside of the containes as defined https://docs.gitlab.com/runner/executors/kubernetes.html#secret-volumes"
  type = object({
    name       = string
    mount_path = string
    read_only  = string
    items      = map(string)
  })

  default = {
    name       = null
    mount_path = null
    read_only  = null
    items      = {}
  }
}

variable "image_pull_secrets" {
  description = "A array of secrets that are used to authenticate Docker image pulling."
  type        = list(string)
  default     = []
}

variable "manager_node_selectors" {
  description = "A map of node selectors to apply to the pods"
  default     = {}
}

variable "manager_node_tolerations" {
  description = "A map of node tolerations to apply to the pods as defined https://docs.gitlab.com/runner/executors/kubernetes.html#other-configtoml-settings"
  default     = {}
}

variable "manager_pod_labels" {
  description = "A map of labels to be added to each build pod created by the runner. The value of these can include environment variables for expansion. "
  default     = {}
}

variable "manager_pod_annotations" {
  description = "A map of annotations to be added to each build pod created by the Runner. The value of these can include environment variables for expansion. Pod annotations can be overwritten in each build. "
  default     = {}
}

variable "additional_secrets" {
  description = "additional secrets to mount into the manager pods"
  type = list(object({
    name  = string
    items = list(map(string))
  }))
  default = []
}

variable "replicas" {
  description = "the number of manager pods to create"
  type        = number
  default     = 1
}

variable "runner_name" {
  description = "name of the runner"
  type        = string
}

variable "cache_secret_name" {
  description = "name of the kubernetes secret that holds the credential file for the cache"
  type        = string
}