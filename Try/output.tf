output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  value = azurerm_virtual_network.main.address_space
}
