resource "azurerm_public_ip" "firewall" {
  name                = "firewall-publicip"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location
  domain_name_label   = "gpa-auth-authentication-2023" # Change this!
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [ azurerm_resource_group.GPA ]
}