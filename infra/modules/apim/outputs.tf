output "apim_name" {
  value = azurerm_api_management.apim.name
}

output "gateway_hostname" {
  value = "${azurerm_api_management.apim.name}.azure-api.net"
}
