# create first backend server
resource "azurerm_container_group" "backend1" {
  name                = "backend-server-1"
  location            = azurerm_resource_group.GPA.location
  resource_group_name = azurerm_resource_group.GPA.name
  os_type             = "Linux"
  restart_policy      = "Always"
  ip_address_type     = "Private"
  subnet_ids          = [azurerm_subnet.proxy.id]
  image_registry_credential {
    username = azurerm_container_registry.gpa.admin_username
    password = azurerm_container_registry.gpa.admin_password
    server   = azurerm_container_registry.gpa.login_server
  }
  container {
    name   = "backend-server-1"
    image  = "${azurerm_container_registry.gpa.login_server}/gpa-backend:latest"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 80//3003
      protocol = "TCP"
    }
    environment_variables = {
      "PORT"      = "80"
      "DBPATH"    = "${azurerm_container_group.mongo.ip_address}:27017"
      "IMAGEPATH" = "${azurerm_public_ip.proxy.ip_address}:80"
      //"IMAGEPATH"="http://localhost:3003"
    }
  }

  tags = {
    environment = "production"
  }
  depends_on = [ azurerm_subnet.proxy, azurerm_container_group.mongo, azurerm_public_ip.proxy ]
}
/*resource "null_resource" "update_IMAGEPATH" {
  provisioner "local-exec" {
    command = <<EOT
      az container update --resource-group ${azurerm_resource_group.GPA.name} --name ${azurerm_container_group.backend1.name} --set IMAGEPATH="${azurerm_container_group.backend1.ip_address}:3003"
    EOT
  }

  depends_on = [azurerm_container_group.backend1]
}*/
