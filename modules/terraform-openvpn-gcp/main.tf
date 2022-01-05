# Uses https://github.com/angristan/openvpn-install to setup VPN in a google VM
# creates and deletes users accordingly

locals {
  metadata = merge(var.metadata, {
    sshKeys = "${var.remote_user}:${tls_private_key.ssh-key.public_key_openssh}"
  })
  ssh_tag          = ["allow-ssh"]
  tags             = toset(concat(var.tags, local.ssh_tag))
  output_folder    = var.output_dir
  private_key_file = "private-key.pem"
}

resource "google_compute_firewall" "allow-external-ssh" {
  name    = "allow-external-ssh-${var.network}"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22", "1194"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = local.ssh_tag
}

resource "google_compute_address" "default" {
  name         = "global-openvpn-ip-${var.network}"
  region       = var.region
  network_tier = var.network_tier
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
}


// SSH Private Key
resource "local_file" "private_key" {
  sensitive_content = tls_private_key.ssh-key.private_key_pem
  filename          = "${var.output_dir}/${local.private_key_file}"
  file_permission   = "0400"
}

resource "random_id" "this" {
  byte_length = "8"
}

resource "random_id" "password" {
  byte_length = "16"
}

module "instance_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "~>6.0.0"
  region               = var.region
  project_id           = var.project_id
  network              = var.network
  subnetwork           = var.subnetwork
  metadata             = local.metadata
  service_account      = var.service_account
  source_image_family  = var.image_family
  source_image         = var.source_image
  source_image_project = var.source_image_project
  disk_size_gb         = var.disk_size_gb

  startup_script = <<SCRIPT
    curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    chmod +x openvpn-install.sh
    mv openvpn-install.sh /home/${var.remote_user}/
    export AUTO_INSTALL=y
    export PASS=1
    /home/${var.remote_user}/openvpn-install.sh
  SCRIPT

  tags   = local.tags
  labels = var.labels

}


module "openvpn_vm" {
  source            = "terraform-google-modules/vm/google//modules/compute_instance"
  version           = "~>6.0.0"
  region            = var.region
  network           = var.network
  subnetwork        = var.subnetwork
  hostname          = var.hostname
  instance_template = module.instance_template.self_link

  access_config = [{
    nat_ip       = google_compute_address.default.address
    network_tier = var.network_tier
  }]
}


resource "null_resource" "openvpn_update_users_script" {
  triggers = {
    users = join(", ", var.users)
  }

  connection {
    type        = "ssh"
    user        = var.remote_user
    host        = google_compute_address.default.address
    private_key = tls_private_key.ssh-key.private_key_pem
  }

  provisioner "file" {
    source      = "${path.module}/scripts/update_users.sh"
    destination = "/home/${var.remote_user}/update_users.sh"
    when        = create
  }

  # Create New User with MENU_OPTION=1
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /etc/openvpn/server.conf ]; do sleep 10; done",
      "chmod +x ~${var.remote_user}/update_users.sh",
      "sudo ~${var.remote_user}/update_users.sh ${join(" ", var.users)}",
    ]
    when = create
  }

  depends_on = [module.openvpn_vm, local_file.private_key]
}

resource "null_resource" "openvpn_download_configurations" {
  depends_on = [null_resource.openvpn_update_users_script]

  triggers = {
    users = join(", ", var.users)
  }

  # Copy .ovpn config for user from server to var.output_dir
  provisioner "local-exec" {
    working_dir = var.output_dir
    command     = <<SCRIPT
      scp -i ${local.private_key_file} \
          -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null \
          ${var.remote_user}@${google_compute_address.default.address}:/home/${var.remote_user}/*.ovpn .
    SCRIPT
    when        = create
  }
}
