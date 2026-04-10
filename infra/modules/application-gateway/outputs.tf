output "public_ip_address" {
  value       = azurerm_public_ip.appgw_pip.ip_address
  description = "Public IP address of the Application Gateway"
}

output "gateway_name" {
  value = azurerm_application_gateway.appgw.name
}

