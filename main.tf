# Main.tf v0 - Brnach Checkpoint1 - C

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

resource "azurerm_public_ip" "sec-publicip1" {
  name                = "tfc1-pip"
  resource_group_name = azurerm_resource_group.sec-rg.name
  location            = azurerm_resource_group.sec-rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "sec-nic1" {
  name                = "lnx1-nic"
  location            = azurerm_resource_group.sec-rg.location
  resource_group_name = azurerm_resource_group.sec-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sec-subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sec-publicip1.id

  }
}

resource "azurerm_network_interface" "sec-nic2" {
  name                = "win1-nic"
  location            = azurerm_resource_group.sec-rg.location
  resource_group_name = azurerm_resource_group.sec-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sec-subnet3.id
    private_ip_address_allocation = "Dynamic"

  }
}



resource "azurerm_network_security_group" "sec-nsg" {
  name                = "tfc-nsg1"
  resource_group_name = azurerm_resource_group.sec-rg.name
  location            = azurerm_resource_group.sec-rg.location
}


resource "azurerm_subnet_network_security_group_association" "sec-subnet-nsg" {
  subnet_id                 = azurerm_subnet.sec-subnet1.id
  network_security_group_id = azurerm_network_security_group.sec-nsg.id

}

resource "azurerm_windows_virtual_machine" "sec-win1" {
  name                = "tcf-win1"
  resource_group_name = azurerm_resource_group.sec-rg.name
  location            = azurerm_resource_group.sec-rg.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  admin_password      = "P@55w0rd!"
  network_interface_ids = [
    azurerm_network_interface.sec-nic2.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-ent-cpc"
    sku       = "win10-21h2-ent-cpc-m365-g2"
    version   = "latest"
  }
}

#ssh key gen 

resource "azurerm_linux_virtual_machine" "sec-lnx1" {
  name                = "tfc-lnc1"
  resource_group_name = azurerm_resource_group.sec-rg.name
  location            = azurerm_resource_group.sec-rg.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.sec-nic1.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    #key1
    public_key = file("C:\Users\steven.christenson/.ssh/id_rsa")
  }

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