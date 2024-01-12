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

resource "azurerm_network_interface" "sec-nic" {
  count               = var.vm_count
  name                = "sec-nic-${count.index}-nic"
  location            = var.loc_name
  resource_group_name = var.rg_name
  tags = {
    DeployedBy = var.tag1
    BU         = var.tag2
  }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.sec-publicip1.id

  }
}

resource "azurerm_linux_virtual_machine" "sec-lnx1" {
  count               = var.vm_count
  name                = "${var.lnx_name}-${count.index}"
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
    azurerm_network_interface.sec-nic[count.index].id
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
