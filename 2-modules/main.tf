# Configure the Azure provider
terraform {
  backend "azurerm" {
    resource_group_name = "adamlash-tfstate"
    storage_account_name = "adamlashtfstate"
    container_name = "state"
    key = "2-modules.tfstate"
  } 
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "alashtfrg-modules"
  location = "westus2"
}

module "network" {
  source              = "./modules/azure-network"
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = "adamtfvnet"
  address_spaces      = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    "subnet1" : ["Microsoft.Sql"], 
    "subnet2" : ["Microsoft.Sql"],
    "subnet3" : ["Microsoft.Sql"]
  }

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.rg]
}