output "url" {
  value = "https://${azurerm_linux_function_app.func.default_hostname}/api"
}
