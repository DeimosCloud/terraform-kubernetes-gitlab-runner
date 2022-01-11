
# ---------------------------------------------------------------------------------------------------------------------
# PUBLIC GKE WITH NODE POOL AND SERVICE ACCOUNT
# ---------------------------------------------------------------------------------------------------------------------
module "gke_cluster" {
  source                       = "DeimosCloud/gke/google"
  version                      = "~>1.0.0"
  name                         = var.cluster_name
  project                      = var.project_id
  location                     = var.region
  network                      = var.network
  subnetwork                   = var.subnet
  cluster_secondary_range_name = var.cluster_secondary_range_name
  release_channel              = "STABLE"
}

#------------------------------------------------------------
# NODE POOL
# Node pool for running regular workloads
#------------------------------------------------------------
module "gke_node_pool" {
  source  = "DeimosCloud/gke/google//modules/gke-node-pool"
  version = "1.0.0"

  project_id = var.project_id
  name       = "default-node-pool"
  cluster    = module.gke_cluster.name
  location   = var.region

  initial_node_count = "1"
  min_node_count     = "1"
  max_node_count     = "5"

  machine_type = var.gke_machine_type

}


#------------------------------------------------------------
# Gitlab Node Pool
# Node pool for running gitlab Jobs
#------------------------------------------------------------
module "gke_node_pool_gitlab" {
  source  = "DeimosCloud/gke/google//modules/gke-node-pool"
  version = "1.0.0"

  project_id = var.project_id
  name       = "gitlab-runner"
  cluster    = module.gke_cluster.name
  location   = var.region

  initial_node_count = "0"
  min_node_count     = "0"
  max_node_count     = "3"

  machine_type = var.runner_machine_type

  # Only pods that tolerate this taint will be scheduled here
  taints = [{
    key    = "node.gitlab.ci/dedicated"
    value  = "true"
    effect = "NO_SCHEDULE"
  }]

  # Labels will be used in node selectors to ensure pods get scheduled to nodes with the same labels
  labels = {
    "node-kind" = "ci"
  }
}



module "gitlab-runner" {
  source = "../"

  release_name              = "gitlab-runner"
  runner_tags               = var.runner_tags
  runner_registration_token = var.runner_registration_token
  namespace                 = var.runner_namespace
  image_pull_secrets        = ["some-pull-secret"]

  # Mount docker socket instead of using docker-in-docker
  mount_docker_socket = true

  # Job pods should be scheduled on nodes with this label
  node_selectors = {
    "node-kind" = "ci"
  }

  # Pods should be able to tolerate taints
  node_tolerations = {
    "node.gitlab.ci/dedicated=true" = "NO_SCHEDULE"
  }

  depends_on = [module.gke_cluster]
}
