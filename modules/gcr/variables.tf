variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "location" {
  description = "(Optional) The location of the registry. One of ASIA, EU, US or not specified. See the official documentation for more information on registry locations. "
  default     = null
}
