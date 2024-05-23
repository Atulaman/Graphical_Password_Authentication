resource "azurerm_firewall" "gpa-firewall" {
  name                = "gpafirewall"
  location            = azurerm_resource_group.GPA.location
  resource_group_name = azurerm_resource_group.GPA.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id = azurerm_firewall_policy.GPA-fwpolicy.id

  ip_configuration {
    name                 = "firewallconfiguration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}