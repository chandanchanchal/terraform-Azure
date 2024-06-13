terraform {
  #cloud {
    #organization = "SabreADI"

    #workspaces {
    #  name = "azure-vnet"
   # }
  #}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}
