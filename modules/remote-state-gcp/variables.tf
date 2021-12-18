variable "bucket_name" {
  description = "(Optional) the name of the bucket"
  default     = null
}

variable "prefix" {
  description = "The name of the Blob used to retrieve/store Terraform's State file inside the Storage Container."
  default     = "global/terrform.tfstate"
}

variable "name_prefix" {
  description = "The prefix for all created resources"
  default     = "tfstate"
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "location" {
  description = "The location of resource group"
  default     = "US-EAST1"
}

variable "backend_output_path" {
  default     = "./backend.tf"
  description = "The default file to output backend configuration to"
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket and all it's contents"
  default     = false
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  default     = null
}

variable "enable_versioning" {
  description = "Enable Bucket versioning"
  default     = true
}
