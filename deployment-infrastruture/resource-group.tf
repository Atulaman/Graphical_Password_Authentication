resource "azurerm_resource_group" "GPA" {
  name     = "GPA-auth"
  location = "west us"
  tags = {
    environment = "production"
  }

}