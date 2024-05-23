resource "azurerm_public_ip" "frontend" {
  name                = "frontend-publicip"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location
  domain_name_label   = "gpa-frontend-authentication-2023" # Change this!
  allocation_method   = "Static"
  sku                 = "Standard"
}