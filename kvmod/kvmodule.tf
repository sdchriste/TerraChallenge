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
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "sec-kv" {
  name                     = var.vlt_name
  resource_group_name      = var.rg_name
  location                 = var.loc_name
  sku_name                 = "standard"
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

#https://medium.com/@pat-st/azure-keyvault-password-creation-using-terraform-d3270cbed371
#https://www.crayon.com/pl/resources/insights/manage-your-secrets-with-terraform-and-azure-key-vault/

#data "azurerm_key_vault" "sec-kv" {
#  name                = var.vlt_name
#  resource_group_name = var.rg_name
#}

resource "random_password" "winpw-admin" {
  length  = 32
  special = true
}

resource "random_password" "linpw-admin" {
  length  = 32
  special = true
}

resource "azurerm_key_vault_secret" "winpw-admin" {
  name         = "winpw-admin"
  key_vault_id = azurerm_key_vault.sec-kv.id
  value        = random_password.winpw-admin.result
}

resource "azurerm_key_vault_secret" "linpw-admin" {
  name         = "linpw-admin"
  key_vault_id = azurerm_key_vault.sec-kv.id
  value        = random_password.linpw-admin.result
}