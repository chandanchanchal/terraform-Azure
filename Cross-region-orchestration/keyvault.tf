# keyvalut 

resource "random_id"  "kv-name" {
 byte_length        = 6
 prefix             = "kv"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv1" {

  name                          = random_id.kv-name.nex
  location                      = azurerm_resource_group.rg.sec.location
  resource_group_name           = azurerm_resource_group.rg.sec.name
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  
  sku = "Standard"

  access_policy {
   tenant_id  = data.azurerm_client_config.current.tenant_id
   object_id  = data.azurerm_client_config.current.object_id

   key_permissions = [
    "Get",
   ]

    secret_permissions = [
    "Get", "Backup", "Delete", "Purge", "Recover", "Restore", "Set",
   ] 

   storage_permissions = [
     "Get",
   ]
  
  }
    
}

# Create VM password

resource "random_password" "vmpassword" {
 length = 20
 special = true 
}

# create key valult secret

resource "azurerm_key_vault_secret" "vmpassword" {

 name               = "vmpassword"
 value              = random_password.vmpassword.result
 key_vault_id       = azurerm_key_vault.kv1.id
 expiration_date    = timeadd(timestamp(),"200")
 content_type       = "Password"

}


