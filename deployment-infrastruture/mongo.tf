# Get the Storage Account Key
data "azurerm_storage_account" "backup" {
  name                = azurerm_storage_account.backup.name
  resource_group_name = azurerm_resource_group.GPA.name
}

/*data "azurerm_storage_account_keys" "backup" {
  name                = azurerm_storage_account.backup.name
  resource_group_name = azurerm_resource_group.GPA.name
}*/
# Create a Container Instance for mongoDB and mount the Azure File Share
resource "azurerm_container_group" "mongo" {
  name                = "example-containergroup"
  location            = azurerm_resource_group.GPA.location
  resource_group_name = azurerm_resource_group.GPA.name
  os_type             = "Linux"
  restart_policy      = "Always"
  image_registry_credential {
    username = azurerm_container_registry.gpa.admin_username
    password = azurerm_container_registry.gpa.admin_password
    server   = azurerm_container_registry.gpa.login_server
  }
  container {
    name   = "mongo-db"
    image  = "${azurerm_container_registry.gpa.login_server}/mongo:latest"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 27017
      protocol = "TCP"
    }

    volume {
      name                 = "gpadbvolume"
      mount_path           = "mnt/files/azure"
      read_only            = false
      share_name           = azurerm_storage_share.DB-Backup.name
      storage_account_name = azurerm_storage_account.backup.name
      storage_account_key  = azurerm_storage_account.backup.primary_access_key
    }
  }
  tags = {
    environment = "production"
  }
  depends_on = [ azurerm_storage_share.DB-Backup ]
}
output "kuchhbhi" {
  value = azurerm_container_group.mongo.ip_address_type
}