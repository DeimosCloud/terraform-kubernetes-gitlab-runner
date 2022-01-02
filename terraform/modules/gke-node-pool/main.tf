/******************************************
  Create Container Cluster node pools
 *****************************************/
resource "google_container_node_pool" "node_pool" {
  provider = google

  name    = var.name
  cluster = var.cluster
  project = var.project_id
  version = var.auto_upgrade ? "" : var.kubernetes_version

  location       = var.location
  node_locations = var.zones

  node_count = var.autoscaling ? null : var.node_count

  initial_node_count = var.autoscaling ? var.initial_node_count : null
  max_pods_per_node  = var.max_pods_per_node

  dynamic "autoscaling" {
    for_each = var.autoscaling ? ["autoscaling"] : []
    content {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  node_config {
    image_type   = var.image_type   # "COS"
    machine_type = var.machine_type # "n1-standard-1"

    labels = var.labels

    metadata = merge(
      var.metadata,
      {
        "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
      },
    )

    dynamic "taint" {
      for_each = var.taints
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    # Add a public tag to the instances. See the network access tier table for full details:
    # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
    tags = var.tags

    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    preemptible  = var.is_preemptible

    service_account = var.service_account

    oauth_scopes = var.oauth_scopes
    dynamic "workload_metadata_config" {
      for_each = var.workload_metadata_config != null ? [var.workload_metadata_config] : []

      content {
        node_metadata = var.workload_metadata_config
      }
    }

    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }
  }


  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}
