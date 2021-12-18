variable "name" {
  type        = string
  description = "Name of image pull Secret"
  default     = "default-gcr-key"
}

variable "namespace" {
  description = "Label name in the namespace"
  default     = "patricia-staging"
}

variable "data" {
  type        = map(string)
  description = "Values to authenticate to GCR"
}