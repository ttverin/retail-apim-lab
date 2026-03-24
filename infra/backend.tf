terraform {
  backend "azurerm" {
    resource_group_name  = "reapimlab-tfstate-rg"
    storage_account_name = "reapimlabtfstatec5hyh"
    container_name       = "tfstate"
    key                  = "reapimlab-platform.tfstate"
  }
}