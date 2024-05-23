resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.GPA.name
  virtual_network_name = azurerm_virtual_network.proxy.name
  address_prefixes     = ["10.10.0.192/26"]
}