variable "project_id" {
  description = "The GCP Project ID"
  default     = null
}

variable "region" {
  description = "The GCP Project Region"
  default     = null
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks."
  type        = string
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  default     = null
}

variable "hostname" {
  description = "Hostname of instances"
  default     = "openvpn"
}

variable "image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "source_image" {
  description = "The source image for the image family. If not specified, terraform will try to create a new instance template anytime an update for an image familty is release"
  type        = string
  default     = "ubuntu-2004-focal-v20210415"
}

variable "source_image_project" {
  type    = string
  default = "ubuntu-os-cloud"
}
variable "disk_size_gb" {
  type    = string
  default = "30"
}

variable "service_account" {
  default = {
    email  = null
    scopes = []
  }
  type = object({
    email  = string,
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}


variable "metadata" {
  description = "Metadata, provided as a map"
  default     = {}
}

variable "network_tier" {
  description = "Network network_tier"
  default     = "STANDARD"
}

variable "labels" {
  default     = {}
  description = "Labels, provided as a map"
}

variable "users" {
  default     = []
  type        = list(string)
  description = "list of user to create"
}

variable "tags" {
  description = "network tags to attach to the instance"
  default     = []
}

variable "output_dir" {
  description = "Folder to store all user openvpn details"
  default     = "openvpn"
}

variable "remote_user" {
  description = "The user to operate as on the VM. SSH Key is generated for this user"
  default     = "ubuntu"
}
