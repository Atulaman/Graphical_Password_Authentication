# create first backend server
resource "azurerm_container_group" "frontend2" {
  name                = "frontend-server-2"
  location            = azurerm_resource_group.GPA.location
  resource_group_name = azurerm_resource_group.GPA.name
  os_type             = "Linux"
  restart_policy      = "Always"
  ip_address_type     = "Private"
  subnet_ids          = [azurerm_subnet.frontend.id]
  image_registry_credential {
    username = azurerm_container_registry.gpa.admin_username
    password = azurerm_container_registry.gpa.admin_password
    server   = azurerm_container_registry.gpa.login_server
  }
  container {
    name   = "frontend-server-2"
    image  = "${azurerm_container_registry.gpa.login_server}/gpa-frontend:latest"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
    environment_variables = {
      REACT_APP_URL = "http://${azurerm_container_group.backend1.ip_address}:80"
    }
  }

  tags = {
    environment = "production"
  }
}
