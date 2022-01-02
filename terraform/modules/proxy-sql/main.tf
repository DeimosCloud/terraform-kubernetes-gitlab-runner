resource "random_id" "this" {
  byte_length = "8"
}

resource "google_compute_instance" "this" {
  name         = "${var.name}-${random_id.this.hex}"
  machine_type = var.machine_type
  zone         = var.zone

  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      type  = var.boot_disk_type
      size  = var.boot_disk_size
    }
  }

  allow_stopping_for_update = true

  network_interface {
    subnetwork = var.subnetwork
    access_config {}
  }

  metadata = {
    ssh-keys = join("\n", [for obj in var.ssh_keys : "${obj.user}:${obj.key}"])
  }
  metadata_startup_script = templatefile("${path.module}/scripts/install.sh", { url = var.proxysql_package_url, db_instance_master_name = var.db_instance_master_name, db_instance_slave_name = var.db_instance_slave_name, mysql_user = var.mysql_user, mysql_password = var.mysql_password, proxysql_admin_password = var.proxysql_admin_password })

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }
}