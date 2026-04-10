locals {
  backend_pool_name       = "apim-backend-pool"
  frontend_port_name      = "frontend-http"
  frontend_ip_config_name = "frontend-public-ip"
  http_setting_name       = "apim-https-settings"
  listener_name           = "http-listener"
  routing_rule_name       = "apim-routing-rule"
  health_probe_name       = "apim-health-probe"
}

resource "azurerm_public_ip" "appgw_pip" {
  name                = "pip-appgw-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-appgw-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = "snet-appgw"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-retail-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection" # switch to Prevention to actively block
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name  = local.backend_pool_name
    fqdns = [var.apim_gateway_hostname]
  }

  probe {
    name                                      = local.health_probe_name
    protocol                                  = "Https"
    path                                      = "/status-0123456789abcdef"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
    probe_name                          = local.health_probe_name
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 100
  }
}

