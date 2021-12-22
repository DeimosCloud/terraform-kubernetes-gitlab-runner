variable "project_id" {
  type    = string
  default = "deimos-internal-playground"
}

variable "credentials" {
  description = "Path to service account file(.json)"
  type        = string
  default     = "sa.json"
}

variable "location" {
  default     = "EU"
  description = "The location of the Region"
}

variable "region" {
  description = "The GCP Project Region"
  default     = "us-east1"
}

variable "zones" {
  description = "The GCP Project Region"
  default     = ["europe-west1-b", "europe-west1-c"]
}

variable "project_name" {
  type    = string
  default = "terraform-team-test"
}
