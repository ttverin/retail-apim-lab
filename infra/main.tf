# Resource Group
module "rg" {
  source   = "./modules/resource-group"
  name     = var.resource_group_name
  location = var.location
}

# Modern backend (Function)
module "product_function" {
  source              = "./modules/function-app"
  name                = "product"
  resource_group_name = module.rg.name
  location            = module.rg.location
  suffix              = local.suffix
  extra_app_settings = {
    SERVICEBUS_CONNECTION = module.service_bus.primary_connection_string
    SERVICEBUS_QUEUE_NAME = module.service_bus.queue_name
    SERVICEBUS_DLQ_NAME   = "${module.service_bus.queue_name}/$DeadLetterQueue"
  }
}

# APIM
module "apim" {
  source              = "./modules/apim"
  name                = "apim-retail-${local.suffix}"
  resource_group_name = module.rg.name
  location            = module.rg.location
  service_url         = module.product_function.url
  function_app_name   = module.product_function.function_app_name
}

# APIM API (modern backend)
module "product_api" {
  source              = "./modules/apim-api"
  api_name            = "product-api"
  path                = "products"
  apim_name           = module.apim.apim_name
  resource_group_name = module.rg.name
  service_url         = module.product_function.url
  policy_file         = "${path.module}/policies/product.xml"
}

# Legacy backend (external system)
module "legacy_api" {
  source              = "./modules/apim-api"
  api_name            = "legacy-product-api"
  path                = "legacy/products"
  apim_name           = module.apim.apim_name
  resource_group_name = module.rg.name
  service_url         = "https://httpbin.org" # simulate legacy system
}

module "service_bus" {

  source              = "./modules/service-bus"
  name                = "sb-retail-${local.suffix}"
  location            = module.rg.location
  resource_group_name = module.rg.name
  queue_name          = "product-queue"
  sku                 = "Basic"
}

module "app_gateway" {
  source                = "./modules/application-gateway"
  suffix                = local.suffix
  location              = module.rg.location
  resource_group_name   = module.rg.name
  apim_gateway_hostname = module.apim.gateway_hostname
}
