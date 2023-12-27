terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #version = "=2.97.0"
      version = "3.84.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_public_ip" "lb_public_ip" {
  name                = var.lbip_name
  resource_group_name = var.rg_name
  location            = var.loc_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  resource_group_name = var.rg_name
  location            = var.loc_name
  #sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "LBRule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"

}
resource "azurerm_lb_probe" "lb_probe" {
  name            = "LBProbe"
  loadbalancer_id = azurerm_lb.lb.id
  port            = 80
  protocol        = "Tcp"
}
