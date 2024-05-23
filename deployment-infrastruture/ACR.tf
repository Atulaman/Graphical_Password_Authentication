resource "azurerm_container_registry" "gpa" {
  name                = "GPA2023"
  resource_group_name = azurerm_resource_group.GPA.name
  location            = azurerm_resource_group.GPA.location
  sku                 = "Standard"
  admin_enabled       = true
}