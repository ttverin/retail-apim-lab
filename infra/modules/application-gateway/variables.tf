variable "suffix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "apim_gateway_hostname" {
  type        = string
  description = "APIM gateway hostname (without https://) e.g. apim-retail-xxx.azure-api.net"
}

