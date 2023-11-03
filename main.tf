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
