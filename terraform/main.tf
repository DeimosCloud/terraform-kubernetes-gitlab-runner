locals {
  project = var.project_name

  common_labels = {
    project     = var.project_name
    managed_by  = "terraform"
  }


  private_vpc_name_split = split("/", module.private_vpc.network)
  private_vpc_name       = element(local.private_vpc_name_split, length(local.private_vpc_name_split) - 1)
}

resource "random_id" "this" {
  byte_length = "8"
}

#PRIVATE CLUSTER
#------------------------------
# VPC
#------------------------------
#"The Virtual Network for the test-env Applications"
module "private_vpc" {
  source               = "gruntwork-io/network/google//modules/vpc-network"
  version              = "~>0.9.0"
  name_prefix          = "${var.project_name}-private-vpc"
  project              = var.project_id
  region               = var.region
  cidr_block           = var.private_vpc_cidr_block
  secondary_cidr_block = var.private_vpc_secondary_cidr_block
 }

# ---------------------------------------------------------------------------------------------------------------------
# PRIVATE GKE WITH NODE POOL AND SERVICE ACCOUNT START
# ---------------------------------------------------------------------------------------------------------------------
module "private_gke_cluster" {
  # Switch to remote URL after https://github.com/gruntwork-io/terraform-google-gke/pull/115 is merged
  # source                       = "gruntwork-io/gke/google//modules/gke-cluster"
  # version                      = "~>0.7.0"
  source                          = "../modules/gke-cluster"
  name                            = "${var.project_name}-private-gke"
  project                         = var.project_id
  location                        = var.region
  network                         = module.private_vpc.network
  subnetwork                      = module.private_vpc.public_subnetwork
  master_ipv4_cidr_block          = var.master_ipv4_cidr_block
  cluster_secondary_range_name    = module.private_vpc.public_subnetwork_secondary_range_name
  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling
  enable_workload_identity        = var.enable_workload_identity
  enable_private_nodes            = "true"
  disable_public_endpoint         = "false"
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "10.8.0.0/16"
          display_name = "private_vpc_cidr_block"
        },
      ]
    },
  ]
  release_channel = var.gke_release_channel
}

#------------------------------
# NODE POOL
#------------------------------
module "private_gke_node_pool" {
  source             = "../modules/gke-node-pool"
  project_id         = var.project_id
  name               = "${local.project}-gke-nodepool"
  cluster            = module.private_gke_cluster.name
  location           = var.region
  initial_node_count = "1"
  min_node_count     = "1"
  max_node_count     = "6"

  image_type   = "COS"
  machine_type = var.machine_type
  disk_type    = var.gke_node_pool_disk_type
  disk_size_gb = var.gke_node_pool_disk_size
  oauth_scopes = var.gke_node_pool_oauth_scopes
  tags         = var.gke_node_pool_tags
  labels = {
    all-pools     = "true"
    gitlab-runner = "false"
  }

  depends_on = [module.private_gke_cluster]
}

module "private_gke_node_pool_gitlab" {
  source     = "../modules/gke-node-pool"
  project_id = var.project_id
  name       = "${local.project}-gke-nodepool-gitlab"
  cluster    = module.private_gke_cluster.name
  location   = var.region
  zones      = ["${var.region}-c"]

  initial_node_count = "1"
  min_node_count     = "1"
  max_node_count     = "2"

  machine_type    = var.runner_machine_type
  image_type      = var.gke_node_pool_image_type
  disk_type       = var.gke_node_pool_disk_type
  disk_size_gb    = var.gke_node_pool_disk_size
  #service_account = module.private_gke_service_account.email
  oauth_scopes    = var.gke_node_pool_oauth_scopes
  tags            = var.gke_node_pool_tags
  taints          = var.gke_node_pool_taints



  labels = merge(local.common_labels, {
    all-pools     = "true"
    gitlab-runner = "true"
  })
}

#--------------------------------------
# OPEN VPN
#--------------------------------------
module "private_openvpn" {
  source     = "../modules/terraform-openvpn-gcp"
  region     = var.region
  project_id = var.project_id
  network    = local.private_vpc_name
  subnetwork = module.private_vpc.public_subnetwork
  hostname   = "${var.project_name}-private-openvpn"
  output_dir = "${path.module}/openvpn"
  tags       = ["public"]
  users      = var.vpn_users
  labels     = local.common_labels
}

#--------------------------------------
# GITLAB SERVER
#--------------------------------------
module "gitlab_server" {
  source                            = "../modules/gitlab-server"
  name                              = "gitlab-server"
  machine_type                      = var.machine_type
  zone                              = "us-east1-c"
  tags                              = var.tags
  subnetwork                        = module.private_vpc.public_subnetwork
  boot_disk_image                   = var.boot_disk_image
  boot_disk_size                    = var.boot_disk_size
  boot_disk_type                    = var.boot_disk_type
  service_account_email             = module.private_gke_service_account.email
  private_vpc_gitlab_source_ranges  = var.private_vpc_gitlab_source_ranges
  private_vpc_network_tag           = var.private_vpc_network_tag
  network                           = module.private_vpc.network
}

module "private_gke_service_account" {
  source                = "gruntwork-io/gke/google//modules/gke-service-account"
  version               = "~>0.6.0"
  name                  = "${local.project}-gke-sa"
  project               = var.project_id
  service_account_roles = var.service_account_roles
  description           = var.cluster_service_account_description
}

#----------------------------------------------------------------------------------------------------------------------
# GITLAB RUNNER START
#data.google_secret_manager_secret_version.private_gke_runner_registration_token.secret_data
#"github.com/DeimosCloud/terraform-kubernetes-gitlab-runner"
#----------------------------------------------------------------------------------------------------------------------
module "private_gitlab_runner" {
  source                    = "../modules/gitlab-runner-master"
  release_name              = "${var.project_name}-runner"
  runner_tags               = var.private_runner_tags
  runner_registration_token = data.google_secret_manager_secret_version.private_gke_runner_registration_token.secret_data
  default_container_image   = var.default_runner_image
  depends_on                = [module.private_gke_cluster]
  mount_docker_socket       = true
  tolerations               = var.gitlab_tolerations
 

  service_account_clusterwide_access = true
  use_local_cache                    = true
}

#-------------------------------------------
# Service Account with read Access to GCR
#-------------------------------------------
module "gcr_reader_service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0.1"
  description   = "Service Account Used by Kubernetes for Read Registry Access (Managed By Terraform)"
  display_name  = "Terraform Managed GCR Reader Service Account"
  generate_keys = true
  project_id    = var.project_id
  prefix        = "${var.project_name}-sa"
  names         = ["gcr-reader"]
  project_roles = [
    "${var.project_id}=>roles/storage.objectViewer",


  ]
}

#------------------------------
#This service has been created will be recreated if uncommented
#Uncomment only if you would like to providion a New Pull Secret
#==================================
# IMAGE PULL SECRET
#------------------------------
module "private_gke_imagepullsecret" {
  source    = "../modules/gke-imagepullsecret"
  name      = var.imagepullsecret_name

  data = {
    ".dockerconfigjson" = <<DOCKER
          {
            "auths": {
              "${data.google_secret_manager_secret_version.registry_server.secret_data}": {
                "auth": "${base64encode("${data.google_secret_manager_secret_version.registry_username.secret_data}:${module.gcr_reader_service_account.key}")}"
              }
            }
          }
          DOCKER
  }
}