resource "azurerm_servicebus_namespace" "sb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

resource "azurerm_servicebus_queue" "queue" {
  name               = var.queue_name
  namespace_id       = azurerm_servicebus_namespace.sb.id
  max_delivery_count = 3 # after 3 failed deliveries, message goes to dead-letter queue
}

resource "azurerm_servicebus_namespace_authorization_rule" "auth_rule" {
  name         = "func-app-access"
  namespace_id = azurerm_servicebus_namespace.sb.id
  listen       = true
  send         = true
  manage       = true
}