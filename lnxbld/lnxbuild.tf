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

resource "azurerm_linux_virtual_machine" "sec-lnx1" {
  name                = var.lnx_name
  resource_group_name = var.rg_name
  location            = var.loc_name
  tags = {
    DeployedBy = var.tag1
    BU         = var.tag2
  }
  size                            = "Standard_B1ms"
  admin_username                  = "adminuser"
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    var.lnx_nic
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
