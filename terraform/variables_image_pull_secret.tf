variable "imagepullsecret_name" {
  description = "Image Pull secret name"
  type        = string
  default     = "dev-gcr-key"
}

variable "gcr_sa_name" {
  description = "Image Pull secret name"
  type        = string
  default     = "projects/deimos-internal-playground/serviceAccounts/ terraform-team-test-gke-sa@deimos-internal-playground.iam.gserviceaccount.com/keys/d020058d8c244b6234aac593388815fd4fa24401"
}