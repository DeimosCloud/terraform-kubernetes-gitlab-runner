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
      image                   = var.runner_image
      gitlabUrl               = var.gitlab_url
      concurrent              = var.concurrent
      runnerRegistrationToken = var.runner_registration_token

      runners = {
        runUntagged = var.run_untagged_jobs
        tags        = var.runner_tags
        locked      = var.runner_locked
        config      = local.config
      }
      rbac = {
        create                    = var.create_service_account
        serviceAccountAnnotations = var.service_account_annotations
        serviceAccountName        = var.service_account
        clusterWideAccess         = var.service_account_clusterwide_access
      }
      nodeSelector   = var.manager_node_selectors
      tolerations    = var.manager_node_tolerations
      podLabels      = var.manager_pod_labels
      podAnnotations = var.manager_pod_annotations
    }),
    local.values_file
  ]

}
