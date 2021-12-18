variable "name" {

}

variable "machine_type" {

}

variable "network" {

}
variable "subnetwork" {

}

variable "zone" {

}

variable "boot_disk_image" {

}

variable "boot_disk_type" {

}

variable "boot_disk_size" {

}

variable "tags" {
  type    = list(any)
  default = []
}

variable "service_account_email" {

}

variable "private_vpc_gitlab_source_ranges" {

}

variable "private_vpc_network_tag" {

}