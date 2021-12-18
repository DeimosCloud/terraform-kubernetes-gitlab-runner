terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.12.26"
}


resource "kubernetes_namespace" "dev_namespace" {
  metadata {
    annotations = {
      annotation_name = var.namespace_annotation_name
    }

    labels = {
      environment = var.labels
    }

    name = var.namespace_name
  }

}