# Main.tf v0.1 - Branch Checkpoint3 - C

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

locals {
  pip_name  = "tfc1-pip"
  nic1_name = "lnx1-nic"
  nic2_name = "win1-nic"
  nsg_name  = "tfc-nsg1"
  win_name  = "tcf-win1"
  lnx_name  = "tfc-lnc"
}
module "resource-group" {
  source   = "./module"
  loc_name = "eastus"
  rg_name  = "rg-tfc"
}

module "kvmod" {
  source   = "./kvmod"
  loc_name = module.resource-group.loc_name
  rg_name  = module.resource-group.rg_name
  vlt_name = "tfc-kvault"
}
module "lbmod" {
  source    = "./lbmod"
  loc_name  = module.resource-group.loc_name
  rg_name   = module.resource-group.rg_name
  lb_name   = "tfc-lb"
  lbip_name = "tfc-lb-ip"
  vn_name   = azurerm_virtual_network.sec-vn.id

}
module "lnxbld" {
  source         = "./lnxbld"
  loc_name       = module.resource-group.loc_name
  rg_name        = module.resource-group.rg_name
  lnx_name       = var.lnx_name
  admin_password = module.kvmod.linpw-admin
  tag1           = var.tag1
  tag2           = var.tag2
  vm_count       = var.vm_count
  lnx_nic        = var.lnx_name
  subnet         = azurerm_subnet.sec-subnet1.id

}

resource "azurerm_virtual_network" "sec-vn" {
  name                = "tcf-network"
  resource_group_name = module.resource-group.rg_name
  location            = module.resource-group.loc_name
  address_space       = ["10.123.0.0/16"]
  tags = {
    DeployedBy = var.tag1
    BU         = var.tag2
  }
}

resource "azurerm_subnet" "sec-subnet1" {
  name                 = var.subnet_1
  resource_group_name  = module.resource-group.rg_name
  virtual_network_name = azurerm_virtual_network.sec-vn.name
  address_prefixes     = ["10.123.1.0/24"]

}


resource "azurerm_subnet" "sec-subnet2" {
  name                 = var.subnet_2
  resource_group_name  = module.resource-group.rg_name
  virtual_network_name = azurerm_virtual_network.sec-vn.name
  address_prefixes     = ["10.123.2.0/24"]
}

resource "azurerm_subnet" "sec-subnet3" {
  name                 = var.subnet_3
  resource_group_name  = module.resource-group.rg_name
  virtual_network_name = azurerm_virtual_network.sec-vn.name
  address_prefixes     = ["10.123.3.0/24"]
}

resource "azurerm_public_ip" "sec-publicip1" {
  name                = local.pip_name
  resource_group_name = module.resource-group.rg_name
  location            = module.resource-group.loc_name
  allocation_method   = "Dynamic"
}



resource "azurerm_network_interface" "sec-nic2" {
  name                = local.nic2_name
  location            = module.resource-group.loc_name
  resource_group_name = module.resource-group.rg_name
  tags = {
    DeployedBy = var.tag1
    BU         = var.tag2
  }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sec-subnet3.id
    private_ip_address_allocation = "Dynamic"

  }
}



resource "azurerm_network_security_group" "sec-nsg" {
  name                = local.nsg_name
  resource_group_name = module.resource-group.rg_name
  location            = module.resource-group.loc_name
  tags = {
    DeployedBy = var.tag1
    BU         = var.tag2
  }
}


resource "azurerm_subnet_network_security_group_association" "sec-subnet-nsg" {
  subnet_id                 = azurerm_subnet.sec-subnet1.id
  network_security_group_id = azurerm_network_security_group.sec-nsg.id

}

resource "azurerm_windows_virtual_machine" "sec-win1" {
  name                = local.win_name
  resource_group_name = module.resource-group.rg_name
  location            = module.resource-group.loc_name
  tags = {
    DeployedBy = var.tag1
    BU         = var.tag2
  }
  size           = "Standard_B1ms"
  admin_username = "adminuser"
  admin_password = module.kvmod.winpw-admin
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

resource "azurerm_recovery_services_vault" "sec-vault" {
  name                = "tfc-vault"
  resource_group_name = module.resource-group.rg_name
  location            = module.resource-group.loc_name
  soft_delete_enabled = false
  tags = {
    DeployedBy = var.tag1
    BU         = var.tag2
  }
  sku = "Standard"

}

resource "azurerm_backup_policy_vm" "sec-bupolicy" {
  name                = "tfc-BackUpP"
  resource_group_name = module.resource-group.rg_name
  recovery_vault_name = azurerm_recovery_services_vault.sec-vault.name
  timezone            = "US Eastern Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }
  retention_daily {
    count = 10
  }
  retention_weekly {
    count    = 4
    weekdays = ["Friday"]
  }
  retention_monthly {
    count    = 12
    weekdays = ["Friday"]
    weeks    = ["First"]
  }
  retention_yearly {
    count    = 10
    weekdays = ["Sunday"]
    weeks    = ["First"]
    months   = ["January"]
  }
}

output "module_server_names" {
  value = module.lnxbld.lnx_name
}

resource "azurerm_backup_protected_vm" "backup-sec-lnx" {
  count               = length(module.lnxbld.lnx_name)
  resource_group_name = module.resource-group.rg_name
  recovery_vault_name = azurerm_recovery_services_vault.sec-vault.name
  source_vm_id        = lookup(module.lnxbld.lnx_name, "${var.lnx_name}-${count.index}", "")
  backup_policy_id    = azurerm_backup_policy_vm.sec-bupolicy.id

}

resource "azurerm_backup_protected_vm" "backup-sec-win" {
  resource_group_name = module.resource-group.rg_name
  recovery_vault_name = azurerm_recovery_services_vault.sec-vault.name
  source_vm_id        = azurerm_windows_virtual_machine.sec-win1.id
  backup_policy_id    = azurerm_backup_policy_vm.sec-bupolicy.id
}




#https://github.com/hashicorp/terraform-provider-azurerm/issues/7802
#https://adityagarg94.medium.com/azure-loadbalancer-fundamentals-how-to-use-nsgs-with-azure-classic-loadbalancer-2-3-1ea57eec2bd9
