resource "azurerm_virtual_network" "proxy" {
  name                = "VNeT"
  address_space       = ["10.10.0.0/24"]
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location
}