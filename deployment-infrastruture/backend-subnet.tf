resource "azurerm_subnet" "proxy" {
  name                 = "backend-subnet"
  resource_group_name  = azurerm_resource_group.GPA.name
  virtual_network_name = azurerm_virtual_network.proxy.name
  address_prefixes     = ["10.10.0.0/25"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "acidelegationservice"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
  depends_on = [ azurerm_virtual_network.proxy ]
}