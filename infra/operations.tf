resource "azurerm_api_management_api_operation" "get_products" {
  operation_id        = "get-products"
  api_name            = module.product_api.api_name
  api_management_name = module.apim.apim_name
  resource_group_name = var.resource_group_name
  display_name        = "Get Products"
  method              = "GET"
  url_template        = "/"
}

resource "azurerm_api_management_api_operation_policy" "get_products_policy" {
  operation_id        = azurerm_api_management_api_operation.get_products.operation_id
  api_name            = module.product_api.api_name
  api_management_name = module.apim.apim_name
  resource_group_name = var.resource_group_name
  xml_content         = <<XML
<policies>
  <inbound>
    <base />
    <rewrite-uri template="/api/productApi" />
    <set-backend-service base-url="https://${module.product_function.function_app_name}.azurewebsites.net" />
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

resource "azurerm_api_management_api_operation" "post_orders" {
  operation_id        = "post-orders"
  api_name            = module.product_api.api_name
  api_management_name = module.apim.apim_name
  resource_group_name = var.resource_group_name
  display_name        = "Submit Order"
  method              = "POST"
  url_template        = "/orders"
}

resource "azurerm_api_management_api_operation_policy" "post_orders_policy" {
  operation_id        = azurerm_api_management_api_operation.post_orders.operation_id
  api_name            = module.product_api.api_name
  api_management_name = module.apim.apim_name
  resource_group_name = var.resource_group_name
  xml_content         = <<XML
<policies>
  <inbound>
    <base />
    <rewrite-uri template="/api/orders" />
    <set-backend-service base-url="https://${module.product_function.function_app_name}.azurewebsites.net" />
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

resource "azurerm_api_management_api_operation" "legacy_get_products" {
  operation_id        = "legacy-get-products"
  api_name            = module.legacy_api.api_name
  api_management_name = module.apim.apim_name
  resource_group_name = var.resource_group_name

  display_name = "Legacy Get Products"
  method       = "GET"
  url_template = "/"
}

resource "azurerm_api_management_api_operation_policy" "legacy_policy" {
  operation_id        = azurerm_api_management_api_operation.legacy_get_products.operation_id
  api_name            = module.legacy_api.api_name
  api_management_name = module.apim.apim_name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-backend-service base-url="https://httpbin.org" />
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