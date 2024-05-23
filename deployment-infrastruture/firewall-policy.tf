resource "azurerm_firewall_policy" "GPA-fwpolicy" {
  name                = "GPA-fwpolicy"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location
}