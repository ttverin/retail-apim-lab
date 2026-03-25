output "url" {
  value = "https://${azurerm_linux_function_app.func.default_hostname}/api"
}

output "function_app_name" {
  value = azurerm_linux_function_app.func.name
}