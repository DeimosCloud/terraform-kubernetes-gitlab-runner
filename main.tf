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
      image = "${var.default_runner_image}"
      [runners.kubernetes.volumes]
      %{if var.mount_docker_socket}
        [[runners.kubernetes.volumes.host_path]]
          name = "docker-socket"
          mount_path = "/var/run/docker.sock"
          read_only = true
          host_path = "/var/run/docker.sock"
      %{endif~}
      %{if var.use_local_cache}
        [[runners.kubernetes.volumes.host_path]]
          name = "cache"
          mount_path = "${var.local_cache_dir}"
          host_path = "${var.local_cache_dir}"
      %{endif~}
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
        create                    = var.rbac_enabled
        serviceAccountAnnotations = var.service_account_annotations
        serviceAccountName        = var.service_account
      }
      runner = {
        serviceAccountName = var.service_account
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
    name  = "concurrent"
    value = var.concurrent
  }


  set {
    name  = "runnerRegistrationToken"
    value = var.runner_registration_token
  }


  set {
    name  = "runners.image"
    value = var.default_runner_image
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
