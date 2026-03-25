resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = "lab"
  publisher_email = "lab@email.com"

  sku_name = "Developer_1"
}

resource "azurerm_api_management_api" "product_api" {
  name                = "product-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Product API"
  path                = "products"
  protocols           = ["https"]
  service_url         = var.service_url
}
