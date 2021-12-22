terraform {
  # required_version = "~> 0.13.0"

  required_providers {
    google      = "~>3.40"
    google-beta = "~>3.40"
    kubernetes  = "~> 1.13"
  }
}

provider "google" {
  region = var.region
  #   zone    = var.zones
  project     = var.project_id
  credentials = file(var.credentials)
}

provider "google-beta" {
  region = var.region
  #   zone        = var.zones
  project     = var.project_id
  credentials = file(var.credentials)
}

provider "kubernetes" {
  load_config_file = false
  alias            = "private"
  #host                   = module.private_gke_cluster.endpoint
  #host                   = var.private_gke_cluster_endpoint
  #token                  = data.google_client_config.provider.access_token
  #cluster_ca_certificate = module.private_gke_cluster.cluster_ca_certificate
}