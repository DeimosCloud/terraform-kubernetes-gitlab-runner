terraform {
  required_version = ">= 0.12"
  required_providers {
    helm        = "~> 1.3"
    kubernetes  = "~> 1.13"
  }