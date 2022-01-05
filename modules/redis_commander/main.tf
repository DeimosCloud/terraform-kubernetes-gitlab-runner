#--------------------------------------
# REDIS COMMANDER
#--------------------------------------

resource "random_id" "this" {
  byte_length = "8"
}

resource "google_compute_address" "static" {
  name = "redis-commander-prod"
}

resource "google_compute_instance" "redis-commander" {
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
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }


  metadata_startup_script = file("${path.module}/scripts/install.sh")

}