terraform {
  required_version = ">= 0.12"

  required_providers {
    google   = ">= 3.29"
    local    = ">= 1.2"
    null     = ">= 2.1"
    template = ">= 2.1"
    random   = ">= 2.1"
  }
}

resource "random_id" "this" {
  byte_length = "10"
}

resource "random_string" "this" {
  length  = 10
  special = false
  upper   = false
}

##### Locals
locals {
  bucket_name = var.bucket_name == null ? "${var.name_prefix}-${random_id.this.hex}" : var.bucket_name
}



#################### GCS
resource "google_storage_bucket" "state" {
  name          = local.bucket_name
  location      = var.location
  project       = var.project_id
  force_destroy = var.force_destroy
  labels        = var.labels

  versioning {
    enabled = var.enable_versioning
  }
}


################# AUTOMATING REMOTE STATE LOCKING
data "template_file" "remote_state" {
  template = file("${path.module}/templates/remote_state.tpl")
  vars = {
    bucket_name        = google_storage_bucket.state.name
    prefix             = var.prefix
    credentials_config = "sa.json"
  }
}

resource "local_file" "remote_state_locks" {
  content  = data.template_file.remote_state.rendered
  filename = var.backend_output_path
}
