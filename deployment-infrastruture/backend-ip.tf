resource "azurerm_public_ip" "proxy" {
  name                = "backend-publicip"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location
  domain_name_label   = "gpa-authentication-2023" # Change this!
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [ azurerm_resource_group.GPA ]
}
output "backend-ip" {
  value = azurerm_public_ip.proxy.ip_address
}