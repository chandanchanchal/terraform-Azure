provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

# Local provisioner to print a message after resource creation
resource "null_resource" "local_message" {
  provisioner "local-exec" {
    command = "echo 'Azure resource group created successfully'"
  }

  depends_on = [azurerm_resource_group.example]
}
