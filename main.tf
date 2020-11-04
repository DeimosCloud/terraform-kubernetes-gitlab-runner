terraform {
  required_version = ">= 0.12"

  required_providers {
    helm       = ">=1.2.3"
    kubernetes = ">=1.11.3"
  }
}

//NAMESPACE
resource "kubernetes_namespace" "gitlab_runner" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "service_account" {
  metadata {
    name      = var.service_account
    namespace = var.namespace
  }
  automount_service_account_token = true
  depends_on                      = [kubernetes_namespace.gitlab_runner]
}

// CLUSTER ROLE
resource "kubernetes_cluster_role" "cluster_role" {
  metadata {
    name = var.cluster_role
  }
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
  depends_on = [kubernetes_namespace.gitlab_runner]
}

//CLUSTER ROLE BINDING
resource "kubernetes_cluster_role_binding" "cluster_role_binding" {
  metadata {
    name = var.cluster_role_binding
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.cluster_role
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.service_account
    namespace = var.namespace
  }
  depends_on = [kubernetes_cluster_role.cluster_role, kubernetes_service_account.service_account]
}

//INSTALL HELM CHART
resource "helm_release" "gitlab_runner" {
  name       = var.release_name
  repository = path.module
  chart      = "gitlab-runner"
  namespace  = var.namespace

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  set {
    type  = "string"
    name  = "runnerRegistrationToken"
    value = var.runner_registration_token
  }

  set {
    type  = "string"
    name  = "runners.serviceAccountName"
    value = var.service_account
  }

  set {
    type  = "string"
    name  = "runners.tags"
    value = var.runner_tags
  }
  depends_on = [kubernetes_cluster_role_binding.cluster_role_binding]
}
