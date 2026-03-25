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

resource "azurerm_api_management_api_operation" "get_products" {
  operation_id        = "get-products"
  api_name            = azurerm_api_management_api.product_api.name
  api_management_name = azurerm_api_management_api.product_api.api_management_name
  resource_group_name = var.resource_group_name
  display_name = "Get Products"
  method       = "GET"
  url_template = "/products"
}


resource "azurerm_api_management_api_operation_policy" "get_products_policy" {
  operation_id        = azurerm_api_management_api_operation.get_products.operation_id
  api_name            = azurerm_api_management_api.product_api.name
  api_management_name = azurerm_api_management_api.product_api.api_management_name
  resource_group_name = var.resource_group_name
  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <rewrite-uri template="/api/productApi" />
    <set-backend-service base-url="https://${var.function_app_name}.azurewebsites.net" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
</policies>
XML
}

