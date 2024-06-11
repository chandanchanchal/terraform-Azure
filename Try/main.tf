resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = try(var.location, "East US")
}

resource "azurerm_virtual_network" "main" {
  name                = try(var.vnet_name, "myVnet")
  address_space       = [try(var.vnet_address_space, "10.0.0.0/16")]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
