# Configure the Azure provider
terraform {
  backend "azurerm" {
    resource_group_name = "adamlash-tfstate"
    storage_account_name = "adamlashtfstate"
    container_name = "state"
    key = "1-basic.tfstate"
  } 
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "alashtfrg"
  location = "westus2"
}

resource "azurerm_storage_account" "storage" {
  name                     = "alashtfstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
