resource "azurerm_api_management_api" "api" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  revision     = "1"
  display_name = var.api_name
  path         = var.path
  protocols    = ["https"]

  service_url = var.service_url
}

resource "azurerm_api_management_api_policy" "policy" {
  count = var.policy_file != "" ? 1 : 0

  api_name            = azurerm_api_management_api.api.name
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name

  xml_content = file(var.policy_file)
}

resource "azurerm_api_management_api" "product_api" {
  name                = "product-api"
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  revision            = "1"
  display_name        = "Product API"
  path                = "products"
  protocols           = ["https"]
}

resource "azurerm_api_management_api" "legacy_api" {
  name                = "legacy-product-api"
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  revision            = "1"
  display_name        = "Legacy Product API"
  path                = "legacy"
  protocols           = ["https"]
}
