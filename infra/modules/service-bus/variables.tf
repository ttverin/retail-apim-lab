variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "sku" {
  type    = string
  default = "Free"
}
variable "resource_group_name" {
  type = string
}
variable "queue_name" {
  type = string
}
