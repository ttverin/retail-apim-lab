variable "location" {
  default = "westeurope"
}

variable "resource_group_name" {
  default = "rg-retail-apim-lab"
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

variable "suffix" {
  type        = string
  default     = null
  nullable    = true
  description = "Optional custom suffix. If null, a random suffix is generated."
}

locals {
  suffix = coalesce(var.suffix, random_string.suffix.result)
}