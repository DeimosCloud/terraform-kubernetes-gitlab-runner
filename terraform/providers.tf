terraform {
  # required_version = "~> 0.13.0"

  required_providers {
    google      = "~>3.40"
    google-beta = "~>3.40"
    kubernetes  = "~>2.0"
    helm        = "~>2.0"
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
  host                   = module.private_gke_cluster.endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = module.private_gke_cluster.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
  host                   = module.private_gke_cluster.endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = module.private_gke_cluster.cluster_ca_certificate
  }
  experiments {
    manifest             = true
  }
}