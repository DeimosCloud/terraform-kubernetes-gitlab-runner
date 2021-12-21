variable "private_runner_tags" {
  description = "Runner Tags"
  type        = string
  default     = "runner-private"
}

variable "default_runner_image" {
  description = "Runner Image"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "gitlab_url" {
  description = "The GitLab Server URL (with protocol) that want to register the runner against"
  default     = "http://34.139.41.59"
}