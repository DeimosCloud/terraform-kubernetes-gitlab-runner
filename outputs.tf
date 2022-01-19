output "namespace" {
  description = "The namespace gitlab-runner was deployed in"
  value       = helm_release.gitlab_runner.namespace
}

output "release_name" {
  description = "The helm release name"
  value       = helm_release.gitlab_runner.name
}

output "chart_version" {
  description = "The chart version"
  value       = helm_release.gitlab_runner.version
}
