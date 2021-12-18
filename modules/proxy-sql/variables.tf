variable "name" {

}

variable "machine_type" {

}

variable "zone" {

}

variable "boot_disk_image" {

}

variable "boot_disk_type" {

}

variable "boot_disk_size" {

}

variable "subnetwork" {

}

variable "proxysql_package_url" {

}

variable "service_account_email" {

}

variable "db_instance_master_name" {

}

variable "db_instance_slave_name" {

}

variable "mysql_user" {

}

variable "mysql_password" {

}
variable "service_account_scopes" {
  type    = list(any)
  default = ["cloud-platform"]
}
variable "tags" {
  type    = list(any)
  default = []
}

variable "ssh_keys" {
  type = list(any)
}

variable "proxysql_admin_password" {
  default = "9tRFVuDmMMQjuZBu"
}