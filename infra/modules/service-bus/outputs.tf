output "namespace_name" {
  value = azurerm_servicebus_namespace.sb.name
}

output "namespace_id" {
  value = azurerm_servicebus_namespace.sb.id
}

output "queue_name" {
  value = azurerm_servicebus_queue.queue.name
}

output "queue_id" {
  value = azurerm_servicebus_queue.queue.id
}

output "primary_connection_string" {
  value     = azurerm_servicebus_namespace_authorization_rule.auth_rule.primary_connection_string
  sensitive = true
}

