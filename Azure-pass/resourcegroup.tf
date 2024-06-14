# resourcegroup.tf
#
# Configure the Azure Provider
provider "azurerm" {
  version = "=1.20.0"
}

locals {
  name = "${var.name}"
  location = "${var.location}"
  tags = "${var.tags}"
}

resource "azurerm_resource_group" "resgrp" {
  # Resource group name
  name = "${local.name}"

  # Resource group location
  location = "${local.location}"

  # Resource group tag
  tags = "${local.tags}"
}