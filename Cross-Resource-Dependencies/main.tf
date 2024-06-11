provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

# Create Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create Subnet
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Output the Resource Group ID
output "resource_group_id" {
  value = azurerm_resource_group.example.id
}

# Output the Virtual Network ID
output "virtual_network_id" {
  value = azurerm_virtual_network.example.id
}

# Output the Subnet ID
output "subnet_id" {
  value = azurerm_subnet.example.id
}
