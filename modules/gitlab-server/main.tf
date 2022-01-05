#--------------------------------------
# GITLAB SERVER
#--------------------------------------
resource "random_id" "this" {
  byte_length = "8"
}

resource "google_compute_address" "static" {
  name = "gitlab-server"
}

resource "google_compute_instance" "gitlab-server" {
  name         = "test-gitlab-server"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      // Ephemeral public IP
  
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = file("${path.module}/scripts/install.sh")
}


resource "google_compute_firewall" "rules" {
  project     = "deimos-internal-playground"
  name        = "my-firewall-rule"
  network     = var.network
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80", "22"]
  }

}