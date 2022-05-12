
locals {
  values_file     = var.values_file != null ? file(var.values_file) : ""
  repository      = "https://charts.gitlab.io"
  chart_name      = "gitlab-runner"
  runner_token    = var.runner_registration_token == null ? var.runner_token : null
  replicas        = var.runner_token != null ? 1 : var.replicas
  gcs_secret_name = lookup(var.cache.gcs, "CredentialsFile", "") != "" ? "google-application-credentials" : lookup(var.cache.gcs, "AccessID", "") != "" ? "gcsaccess" : ""

  cache_secret_config = {
    s3    = "s3access"
    azure = "azureaccess"
    gcs   = local.gcs_secret_name
  }
  cache_secret_name = lookup(local.cache_secret_config, var.cache.type, "")
}

