variable "private_vpc_cidr_block" {
  description = "The IP address range of the VPC in CIDR notation"
  type        = string
  default     = "10.8.0.0/16"
}

variable "private_vpc_secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation"
  type        = string
  default     = "10.6.0.0/16"
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = "10.5.0.0/28"
}

variable "private_vpc_network_tag" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation"
  type        = list(string)
  default     = ["gke-private-gke-dev-3e46fc7b-node"]
}

variable "private_vpc_gitlab_source_ranges" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation"
  type        = list(string)
  default     = ["10.138.17.27/32"]
}