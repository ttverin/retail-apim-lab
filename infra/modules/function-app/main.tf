resource "azurerm_storage_account" "sa" {
  name                     = "st${var.name}${var.suffix}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                       = "func-${var.name}-${var.suffix}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  app_settings = merge(
    {
      FUNCTIONS_WORKER_RUNTIME              = "node"
      APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.app_insights.instrumentation_key
      APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insights.connection_string
      WEBSITE_RUN_FROM_PACKAGE              = "1"
    },
    var.extra_app_settings
  )
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.name}-ai"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  lifecycle {
    ignore_changes = [workspace_id]
  }
}


output "function_name" {
  value = azurerm_linux_function_app.func.name
}

output "application_insights_key" {
  value = azurerm_application_insights.app_insights.instrumentation_key
}