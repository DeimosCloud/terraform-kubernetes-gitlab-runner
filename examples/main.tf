module "gitlab_runner" {
  source       = "../"
  release_name = "gitlab-runner"

  runner_tags               = var.runner_tags
  runner_registration_token = var.runner_registration_token
  default_runner_image      = var.default_runner_image
  values_file               = "${path.module}/gitlab-runner-values.yaml"
}
