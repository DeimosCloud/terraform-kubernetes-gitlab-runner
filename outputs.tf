output "namespace" {
  description = "The namespace gitlab-runner was deployed in"
  value       = var.namespace
}

output "release_name" {
  description = "The helm release name"
  value       = var.release_name
}

