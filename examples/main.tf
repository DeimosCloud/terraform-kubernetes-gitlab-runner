locals {
  labels = {
    "node-kind" = "ci"
  }

}


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
resource "google_container_node_pool" "gke_node_pool" {
  name               = "default-node-pool"
  cluster            = module.gke_cluster.name
  initial_node_count = "1"

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    image_type   = "COS"
    machine_type = var.gke_machine_type
  }
}


#------------------------------------------------------------
# Gitlab Node Pool
# Node pool for running gitlab Jobs
#------------------------------------------------------------
resource "google_container_node_pool" "gitlab_runner_pool" {
  name               = "gitlab-runner"
  cluster            = module.gke_cluster.name
  initial_node_count = "0"

  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }

  node_config {
    image_type   = "COS"
    machine_type = var.runner_machine_type

    # Labels will be used in node selectors to ensure pods get scheduled to nodes with the same labels
    labels = local.labels

    # Only pods that tolerate this taint will be scheduled here
    taint = [{
      key    = "node.gitlab.ci/dedicated"
      value  = "true"
      effect = "NO_SCHEDULE"
    }]
  }

}


module "gitlab-runner" {
  source = "../"

  release_name              = "gitlab-runner"
  runner_tags               = var.runner_tags
  runner_registration_token = var.runner_registration_token
  namespace                 = var.runner_namespace
  image_pull_secrets        = ["some-pull-secret"]
  runner_name               = "my-runner"

  # Mount docker socket instead of using docker-in-docker
  build_job_mount_docker_socket = true

  # pods should be scheduled on nodes with this label
  build_job_node_selectors = local.labels
  manager_node_selectors   = local.labels

  # Pods should be able to tolerate taints
  manager_node_tolerations = [{
    key      = "node.gitlab.ci/dedicated"
    operator = "Exists"
    effect   = "NO_SCHEDULE"
  }]

  build_job_node_tolerations = {
    "node.gitlab.ci/dedicated=true" = "NO_SCHEDULE"
  }

  depends_on = [google_container_node_pool.gitlab_runner_pool]
}
