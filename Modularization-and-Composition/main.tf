provider "azurerm" {
  features {}
}

module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnet_name         = var.subnet_name
  subnet_prefix       = var.subnet_prefix
}

module "vm" {
  source              = "./modules/vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  nic_name            = var.nic_name
  subnet_id           = module.vnet.subnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}
