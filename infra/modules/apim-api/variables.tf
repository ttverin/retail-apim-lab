variable "api_name" {}
variable "path" {}
variable "apim_name" {}
variable "resource_group_name" {}
variable "service_url" {}

variable "policy_file" {
  default = ""
}
variable "function_app_name" {
  type = string
}