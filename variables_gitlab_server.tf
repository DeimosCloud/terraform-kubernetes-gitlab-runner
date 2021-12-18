variable "tags" {
  type    = list(any)
  default = ["gitlab-server"]

}

variable "boot_disk_image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "boot_disk_type" {
  type    = string
  default = "pd-ssd"
}

variable "boot_disk_size" {
  type    = string
  default = "20"
}