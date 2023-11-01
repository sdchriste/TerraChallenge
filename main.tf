# Main.tf v0 - Brnach Checkpoint1 

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
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
