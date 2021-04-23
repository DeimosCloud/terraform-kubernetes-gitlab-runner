locals {
  values_file = var.values_file != null ? file(var.values_file) : ""
  repository  = "https://charts.gitlab.io"
  chart_name  = "gitlab-runner"

  // Config variables
  cache = ! var.use_local_cache ? "" : <<EOF
  EOF

  config = <<EOF
  [[runners]]
  %{if var.use_local_cache~}
    cache_dir = "${var.local_cache_dir}"
  %{endif~}
    [runners.kubernetes]
    %{~if var.default_container_image != null~}
      image = "${var.default_container_image}"
    %{~endif~}
    %{~if var.create_service_account == true~}
      service_account = "${var.release_name}-${var.service_account}"
    %{~else~}
      service_account = "${var.service_account}"
    %{~endif~}
      priviledged = ${var.priviledged}
      [runners.kubernetes.affinity]
      [runners.kubernetes.node_selector]
      [runners.kubernetes.pod_labels]
      [runners.kubernetes.pod_security_context]
      %{~if var.mount_docker_socket~}
        fs_group = ${var.docker_fs_group}
      %{~endif~}
      %{~if var.run_container_as_user != null~}
        run_as_user: ${var.run_container_as_user}
      %{~endif~}
      [runners.kubernetes.volumes]
      %{~if var.mount_docker_socket~}
        [[runners.kubernetes.volumes.host_path]]
          name = "docker-socket"
          mount_path = "/var/run/docker.sock"
          read_only = true
          host_path = "/var/run/docker.sock"
      %{~endif~}
      %{~if var.use_local_cache~}
        [[runners.kubernetes.volumes.host_path]]
          name = "cache"
          mount_path = "${var.local_cache_dir}"
          host_path = "${var.local_cache_dir}"
      %{~endif~}
  EOF
}

//INSTALL HELM CHART
resource "helm_release" "gitlab_runner" {
  name             = var.release_name
  repository       = local.repository
  chart            = local.chart_name
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = var.create_namespace


  values = [
    yamlencode({
      rbac = {
        create                    = var.create_service_account
        serviceAccountAnnotations = var.service_account_annotations
        serviceAccountName        = var.service_account
        clusterWideAccess         = var.service_account_clusterwide_access
      }
    }),
    local.values_file
  ]

  set {
    type  = "string"
    name  = "gitlabUrl"
    value = var.gitlab_url
  }

  set {
    name  = "image"
    value = "gitlab/gitlab-runner:${var.runner_image_tag}"
  }

  set {
    name  = "concurrent"
    value = var.concurrent
  }


  set {
    name  = "runnerRegistrationToken"
    value = var.runner_registration_token
  }

  set {
    name  = "runners.runUntagged"
    value = var.run_untagged_jobs
  }

  set {
    type  = "string"
    name  = "runners.tags"
    value = var.runner_tags
  }

  set {
    type  = "string"
    name  = "runners.locked"
    value = var.runner_locked
  }

  set {
    type  = "string"
    name  = "runners.config"
    value = local.config
  }
}
