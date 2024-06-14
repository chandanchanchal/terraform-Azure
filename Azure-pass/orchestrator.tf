# orchestrator.tf
#
# Configure the Azure Provider
provider "azurerm" {
  version = "=1.20.0"
}

# Initialise external variables
variable "resource_name" {
  type = "string"
  description = "Resource name"
}

variable "resource_environment" {
  type = "string"
  description = "Resource environment"
  default = "Development"
}

variable "resource_environment_code" {
  type = "string"
  description = "Resource environment code"
  default = "dev"
}

variable "resource_location" {
  type = "string"
  description = "Resource location"
  default = "Australia Southeast"
}

variable "resource_location_code" {
  type = "string"
  description = "Resource location code"
  default = "ase"
}

# Initialise local variables
locals {
  resource_long_name = "{0}-${var.resource_name}-${var.resource_environment_code}-${var.resource_location_code}"
  resource_short_name = "${replace(local.resource_long_name, "-", "")}"
  location = "${var.resource_location}"
  tags = {
    environment = "${var.resource_environment}"
  }
}

# Create Resource Group
module "resgrp" {
  source = "./modules/resourcegroup"

  name = "${replace(local.resource_long_name, "{0}", "resgrp")}"
  location = "${local.location}"
  tags = "${local.tags}"
}

# Create Storage Account
module "st" {
  source = "./modules/storageaccount"

  name = "${replace(local.resource_short_name, "{0}", "st")}"
  location = "${local.location}"
  resource_group = "${module.resgrp.name}"
  tags = "${local.tags}"
}

# Create Consumption Plan
module "csplan" {
  source = "./modules/consumptionplan"

  name = "${replace(local.resource_long_name, "{0}", "csplan")}"
  location = "${local.location}"
  resource_group = "${module.resgrp.name}"
  tags = "${local.tags}"
}

# Create Function App
module "fncapp" {
  source = "./modules/functionapp"

  name = "${replace(local.resource_long_name, "{0}", "fncapp")}"
  location = "${local.location}"
  resource_group = "${module.resgrp.name}"
  tags = "${local.tags}"

  consumption_plan_id = "${module.csplan.id}"

  web_config = {
    https_only = "true"
    use_32_bit_worker_process = "false"
  }

  app_settings = {
    storage_connection_string = "${module.st.connection_string}"
    secret_storage_type = "Files"
    functions_extension_version = "~2"
    functions_edit_mode = "ReadOnly"
    functions_worker_runtime = "dotnet"
  }
}

# Create Logic App
module "logapp" {
  source = "./modules/logicapp"

  name = "${replace(local.resource_long_name, "{0}", "logapp")}"
  location = "${local.location}"
  resource_group = "${module.resgrp.name}"
  tags = "${local.tags}"
}