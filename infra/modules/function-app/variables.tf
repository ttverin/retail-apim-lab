variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "suffix" {
  type = string
}

variable "extra_app_settings" {
  type    = map(string)
  default = {}
}

