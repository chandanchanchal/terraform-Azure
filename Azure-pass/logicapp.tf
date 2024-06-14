# logicapp.tf
#
# Configure the Azure Provider
provider "azurerm" {
  version = "=1.20.0"
}

locals {
  name = "${var.name}"
  location = "${var.location}"
  resource_group = "${var.resource_group}"
  tags = "${var.tags}"
}

resource "azurerm_logic_app_workflow" "logapp" {
  # Logic App name
  name = "${local.name}"

  # Logic App location
  location = "${local.location}"

  # Resource group name that Logic App belongs
  resource_group_name = "${local.resource_group}"

  # Resouce tags
  tags = "${local.tags}"
}