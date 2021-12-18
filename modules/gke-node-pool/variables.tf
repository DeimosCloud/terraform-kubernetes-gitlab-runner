variable "project_id" {
  type        = string
  description = "name of the google project"
}

variable "cluster" {
  type        = string
  description = "Name of GKE cluster"
}


variable "location" {
  type        = string
  description = "(Optional) The region/zone the cluster is in"
  default     = null
}


variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = null
}


variable "node_count" {
  description = "(optional) Number of nodes to be deployed. Should not be used alongside autoscaling"
  default     = "1"
}

variable "autoscaling" {
  description = "Whether to enable autoscaling. Values of min_node_count and max_node_count will be used"
  default     = true
}

variable "initial_node_count" {
  type        = string
  description = "(optional) Number of nodes to be deployed when Autoscaling is enabled"
  default     = "3"
}

variable "min_node_count" {
  type        = string
  description = "(optional) Minimum amount of Nodes when autoscaling is enabled"
  default     = "1"
}

variable "name" {
  type        = string
  description = "node pool name"
}

variable "max_node_count" {
  type        = string
  description = "(optional) Maximum amount Node when autoscaling enabled "
  default     = "5"
}

variable "image_type" {
  type        = string
  description = "(optional) The type of image to be used"
  default     = "COS"
}

variable "machine_type" {
  type        = string
  description = "(optional) The type of machine to deployed"
  default     = null
}

variable "service_account" {
  type        = string
  description = "(optional) Service account created GKE"
  default     = null
}

variable "labels" {
  description = "maps containing node label"
  type        = map(string)
  default     = {}
}

variable "disk_size_gb" {
  default     = 30
  description = "(Optional) Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB"
}

variable "disk_type" {
  default     = "pd-standard"
  description = "(Optional) Type of the disk attached to each node (e.g. 'pd-standard', 'pd-balanced' or 'pd-ssd')."
}

variable "taints" {
  default = []
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  description = "(Optional) A list of Kubernetes taints to apply to nodes"
}

variable "is_preemptible" {
  default     = false
  description = "A boolean that represents whether or not the underlying node VMs are preemptible"
}

variable "oauth_scopes" {
  description = "(Optional) Scopes that are used by NAP when creating node pools."
  default     = []
  type        = list(string)
}

variable "workload_metadata_config" {
  description = "Metadata configuration to expose to workloads on the node pool."
  default     = null
  type        = string
}

variable "enable_secure_boot" {
  description = "Defines if the instance has Secure Boot enabled."
  default     = false
}

variable "enable_integrity_monitoring" {
  description = "(Optional) Defines if the instance has integrity monitoring enabled."
  default     = true
}

variable "disable_legacy_metadata_endpoints" {
  description = "disable-legacy-endpoints metadata set"
  default     = true
}

variable "create_timeout" {
  default = "30m"
}

variable "delete_timeout" {
  default = "30m"
}

variable "update_timeout" {
  default = "30m"
}

variable "auto_repair" {
  description = "(Optional) Whether the nodes will be automatically repaired."
  default     = true
}

variable "auto_upgrade" {
  description = "(Optional) Whether the nodes will be automatically upgraded."
  default     = true
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version for the nodes in this pool"
  default     = null
}

variable "max_pods_per_node" {
  default     = null
  description = "(Optional) The maximum number of pods per node in this node pool."
}

variable "metadata" {
  default     = {}
  description = "Optional) The metadata key/value pairs assigned to nodes in the node pool"
}

variable "tags" {
  description = "(Optional) The list of instance tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls."
  default     = []
}
