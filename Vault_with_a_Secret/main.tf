#Resource datasource 
resource "azurerm_resource_group" "rg1"{
name        = var.azure-rg-1
location    = var.loc1
tags = {
  Environment = var.environment_tag
}
}

# Create keyVault ID

resource "random_id" "kvname"{
  byte_length = 5
  prefix = "keyVault"
}



provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# keyVault Creation
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  name                        = random_id.kvname.hex
  depends_on                  = [azurerm_resource_group.rg1]
  location                    = var.loc1
  resource_group_name         = var.azure-rg-1
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Backup" , "Delete", "List", "Recover", "Restore" , "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }

   tags = {
    Environment = var.environment_tag
   }
}

# Create Key Vault VM password
resource "random_password" "vmpassword"{
 length   = 20
 special  = true
}
  
# Create Key Vault Secret
  resource "azurerm_key_vault_secret" "vmpassword" {

   name         = "vmpassword"
   value        =  random_password.vmpassword.id
   key_vault_id =  azurerm_key_vault.kv1.id
   depends_on   =  [azurerm_key_vault.kv1]
    
  }