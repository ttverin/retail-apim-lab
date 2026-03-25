resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = "lab"
  publisher_email = "lab@email.com"

  sku_name = "Developer_1"
}



