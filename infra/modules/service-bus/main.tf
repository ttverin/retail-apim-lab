resource "azurerm_servicebus_namespace" "sb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

resource "azurerm_servicebus_queue" "queue" {
    name                = var.queue_name
    namespace_id        = azurerm_servicebus_namespace.sb.id
}

resource "azurerm_servicebus_namespace_authorization_rule" "auth_rule" {
    name                = "RootManageSharedAccessKey"
    namespace_id        = azurerm_servicebus_namespace.sb.id
    listen              = true
    send                = true
    manage              = true
}