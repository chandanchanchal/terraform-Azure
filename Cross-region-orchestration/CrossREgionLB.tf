# puplic IP - cross Region Load Balancer

resource "azurerm_public_ip" "pip_cr_lb" {
  name                = "pip-cross-region1.location"
  location            = var.regions.region1.location
  resource_group_name = "rg-${var-regions.region1.location}-con"
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "lb-global-${random_id.dns-name.hex}"
  depends_on          = [azurerm_resource_group.rg-con]
}

# cross - Region load balancer
resource "azurerm_lb" "cross-region-lb" {
  name                = "cross-regions-lb-${var.regions.region1.location}"
  location            = var.regions.region1.location
  resource_group_name = "rg-${var.regions.region1.location}-con"
  sku                 = "Standard"
  sku_tier            = "Global"
  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip-cr-lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "cress-region-lb-pool" {
  loadbalancer_id = azurerm_lb.cross-region-lb.id
  name            = "BackendAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "cress-region-lb-pool-address" {
  for_each                            = var.regions
  name                                = "regional-lb-${each.value.location}"
  backend_address_pool_id             = azure_lb_backend_address_pool.cross-region-lb-pool.id
  backend_address_ip_configuration_id = azurerm_lb_.regional-lb[each.key].frontend_ip_configguration[0].id

}

resource "azurerm_lb_rule" "cross-region-lb-rule" {
  loadbalancer_id                = azurerm_lb.cross-region-lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.cross-region-lb.frontend_ip_configguration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool_address_pool.cross-region-lb-pool.id]
}
