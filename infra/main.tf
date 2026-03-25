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
  apim_name           = module.apim.name
  resource_group_name = module.rg.name
  service_url         = module.product_function.url

  policy_file = "${path.module}/policies/product.xml"
}

# Legacy backend (external system)
module "legacy_api" {
  source              = "./modules/apim-api"
  api_name            = "legacy-product-api"
  path                = "legacy/products"
  apim_name           = module.apim.name
  resource_group_name = module.rg.name
  service_url         = "https://httpbin.org" # simulate legacy system
}
