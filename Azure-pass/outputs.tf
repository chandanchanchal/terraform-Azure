# outputs.tf
#
# Resource group ID
output "id" {
  value = "${azurerm_resource_group.resgrp.id}"
}

# Resource Group name
output "name" {
  value = "${azurerm_resource_group.resgrp.name}"
}

# Resource Group location
output "location" {
  value = "${azurerm_resource_group.resgrp.location}"
}