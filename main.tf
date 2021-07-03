locals {
  values_file = var.values_file != null ? file(var.values_file) : ""
  repository  = "https://charts.gitlab.io"
  chart_name  = "gitlab-runner"
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
