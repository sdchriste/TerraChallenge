# Main.tf v0 - Brnach Checkpoint1 - C

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "=2.97.0"
      version = "3.79.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sec-rg" {
  name     = "rg-tfc"
  location = "East Us"
 
}

resource "azurerm_virtual_network" "sec-vn" {
  name                = "tfc-network"
  resource_group_name = azurerm_resource_group.sec-rg.name
  location            = azurerm_resource_group.sec-rg.location
  address_space       = ["10.123.0.0/16"]

  }

  resource "azurerm_subnet" "sec-subnet1" {
  name                 = "Web"
  resource_group_name  = azurerm_resource_group.sec-rg.name
  virtual_network_name = azurerm_virtual_network.sec-vn.name
  address_prefixes     = ["10.123.1.0/24"]
  }

  resource "azurerm_subnet" "sec-subnet2" {
  name                 = "Data"
  resource_group_name  = azurerm_resource_group.sec-rg.name
  virtual_network_name = azurerm_virtual_network.sec-vn.name
  address_prefixes     = ["10.123.2.0/24"]
  }

  resource "azurerm_subnet" "sec-subnet3" {
  name                 = "JumpBox"
  resource_group_name  = azurerm_resource_group.sec-rg.name
  virtual_network_name = azurerm_virtual_network.sec-vn.name
  address_prefixes     = ["10.123.3.0/24"]
  }