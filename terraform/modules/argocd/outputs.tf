output "namespace" {
  description = "the kubernetes namespace of the release"
  value       = helm_release.argocd.namespace
}

output "release_name" {
  description = "the name of the release"
  value       = helm_release.argocd.name
}

output "server_url" {
  description = "The server URL of argocd created by ingress"
  value       = var.ingress_host
}
