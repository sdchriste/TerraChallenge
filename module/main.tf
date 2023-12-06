terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #version = "=2.97.0"
      version = "3.79.0"
    }
  }
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sec-rg" {
  name     = var.rg_name
  location = var.loc_name
}

