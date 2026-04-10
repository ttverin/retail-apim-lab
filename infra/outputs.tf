output "resource_group_name" {
  value = module.rg.name
}

output "location" {
  value = module.rg.location
}

output "function_app_name" {
  value = module.product_function.function_app_name
}

output "function_app_url" {
  value = module.product_function.url
}

output "apim_name" {
  value = module.apim.apim_name
}

output "service_bus_namespace_name" {
  value = module.service_bus.namespace_name
}

output "service_bus_namespace_id" {
  value = module.service_bus.namespace_id
}

output "service_bus_queue_name" {
  value = module.service_bus.queue_name
}

output "service_bus_queue_id" {
  value = module.service_bus.queue_id
}

output "app_gateway_name" {
  value = module.app_gateway.gateway_name
}

output "app_gateway_public_ip" {
  value = module.app_gateway.public_ip_address
}

