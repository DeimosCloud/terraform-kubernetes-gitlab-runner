variable "cluster_name" {
  description = "The name of the GKE cluster to create"
}

variable "project_id" {
  description = "the project ID on GCP"
}

variable "region" {
  description = "the region to deploy the cluster in"
}

variable "network" {
  description = "The name of the VPC to deploy the cluster in"
}

variable "subnet" {
  description = "The subnet name to deploy the cluster in within the VPC"
}

variable "cluster_secondary_range_name" {
  description = "The secondary subnet name to use when assigning IPs in the cluster"
}

variable "gke_machine_type" {
  description = "The machine types to use as node"
}

variable "runner_tags" {
  description = "The tags to register the runner with. This tags will be used on gitlab to be able to run jobs on the runner"
}

variable "runner_registration_token" {
  description = "The token (gotten from gitlab) to use during runner registration"
}

variable "runner_namespace" {
  description = "The namespace to deploy the runner in"
}

variable "runner_machine_type" {
  description = "The machine type to use when creating the node pools"
}

