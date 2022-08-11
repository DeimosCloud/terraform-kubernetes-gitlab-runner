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
  type        = map(any)
}

variable "service_account_clusterwide_access" {
  description = "Run the gitlab-bastion container with the ability to deploy/manage containers of jobs cluster-wide or only within namespace"
  default     = false
  type        = bool
}

variable "chart_version" {
  description = "The version of the chart"
  default     = "0.40.1"
  type        = string
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
  type        = bool
}

variable "release_name" {
  description = "The helm release name"
  default     = "gitlab-runner"
  type        = string
}

variable "atomic" {
  description = "whether to deploy the entire module as a unit"
  type        = bool
  default     = true
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
  type        = map(any)
}

variable "gitlab_url" {
  description = "The GitLab Server URL (with protocol) that want to register the runner against"
  default     = "https://gitlab.com/"
  type        = string
}

variable "concurrent" {
  default     = 10
  description = "Configure the maximum number of concurrent jobs"
  type        = number
}

variable "create_service_account" {
  default     = true
  description = "If true, the service account, it's role and rolebinding will be created, else, the service account is assumed to already be created"
  type        = bool
}

variable "local_cache_dir" {
  default     = "/tmp/gitlab/cache"
  description = "Path on nodes for caching"
  type        = string
}

variable "build_job_hostmounts" {
  description = "A list of maps of name:{host_path, container_path, read_only} for which each named value will result in a hostmount of the host path to the container at container_path.  If not given, container_path fallsback to host_path:   dogstatsd = { host_path = '/var/run/dogstatsd' } will mount the host /var/run/dogstatsd to the same path in container."
  default     = {}
  type        = map(map(any))
}

variable "build_job_mount_docker_socket" {
  default     = false
  description = "Whether to hostmount the /var/run/docker.sock from host into the build container"
  type        = bool
}

variable "build_job_pvcs" {
  default     = {}
  description = "A map of path:config for which each values' path is where the Persistent Volume so named should be mounted in the build container.  ie: build_job_pvcs = { '/root/caches/other-cache' = { name = 'vol-12345678' } }"
  type        = map(map(string))
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
  type        = number
}

variable "build_job_node_selectors" {
  description = "A map of node selectors to apply to the pods"
  default     = {}
  type        = map(string)
}

variable "build_job_node_tolerations" {
  description = "A map of node tolerations to apply to the pods as defined https://docs.gitlab.com/runner/executors/kubernetes.html#other-configtoml-settings"
  default     = {}
  type        = map(string)
}

variable "build_job_pod_labels" {
  description = "A map of labels to be added to each build pod created by the runner. The value of these can include environment variables for expansion. "
  default     = {}
  type        = map(string)
}

variable "build_job_pod_annotations" {
  description = "A map of annotations to be added to each build pod created by the Runner. The value of these can include environment variables for expansion. Pod annotations can be overwritten in each build. "
  default     = {}
  type        = map(string)
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
  type        = map(string)
}

variable "manager_node_tolerations" {
  description = "A map of node tolerations to apply to the pods as defined https://docs.gitlab.com/runner/executors/kubernetes.html#other-configtoml-settings"
  default     = {}
  type        = map(string)
}

variable "manager_pod_labels" {
  description = "A map of labels to be added to each build pod created by the runner. The value of these can include environment variables for expansion. "
  default     = {}
  type        = map(string)
}

variable "manager_pod_annotations" {
  description = "A map of annotations to be added to each build pod created by the Runner. The value of these can include environment variables for expansion. Pod annotations can be overwritten in each build. "
  default     = {}
  type        = map(string)
}

variable "additional_secrets" {
  description = "additional secrets to mount into the manager pods"
  type        = list(map(string))
  default     = []
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

variable "unregister_runners" {
  description = "whether runners should be unregistered when pool is deprovisioned"
  type        = bool
  default     = true
}

variable "runner_token" {
  description = "token of already registered runer. to use this var.runner_registration_token must be set to null"
  type        = string
  default     = null
}

variable "cache" {
  description = "Describes the properties of the cache. type can be either of ['local', 'gcs', 's3', 'azure'], path defines a path to append to the bucket url, shared specifies whether the cache can be shared between runners. you also specify the individual properties of the particular cache type you select. see https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscache-section"
  type = object({
    type   = string
    path   = string
    shared = bool
    gcs    = map(any)
    s3     = map(any)
    azure  = map(any)
  })

  validation {
    condition     = var.cache.type == "gcs" ? lookup(var.cache.gcs, "CredentialsFile", "") != "" || lookup(var.cache.gcs, "AccessID", "") != "" : true
    error_message = "To use the gcs cache type you must set either CredentialsFile or AccessID and PrivateKey in var.cache.gcs. see https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscache-section for config details."
  }
  validation {
    condition     = var.cache.type == "azure" ? length(var.cache.azure) > 0 : true
    error_message = "To use the azure cache type you must set var.cache.azure. see https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscache-section for config details."
  }
  validation {
    condition     = var.cache.type == "s3" ? length(var.cache.s3) > 0 : true
    error_message = "To use the s3 cache type you must set var.cache.s3 see https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscache-section for config details."
  }

  validation {
    condition     = var.cache.type == "gcs" || var.cache.type == "s3" || var.cache.type == "local" || var.cache.type == "azure" ? true : false
    error_message = "Cache type must be one of 's3', 'gcs', 'azure', or 'local'."
  }

  default = {
    type   = "local"
    path   = ""
    shared = false
    gcs    = {}
    s3     = {}
    azure  = {}
  }
}

variable "build_job_limits" {
  description = "The CPU allocation given to and the requested for build containers"
  type        = map(any)
  default = {
    cpu    = "2"
    memory = "1Gi"
  }
}

variable "build_job_requests" {
  description = "The CPU allocation given to and the requested for build containers"
  type        = map(any)
  default = {
    cpu    = "1"
    memory = "512Mi"
  }
}

