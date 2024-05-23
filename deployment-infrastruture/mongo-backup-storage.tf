# Create a Storage Account
resource "azurerm_storage_account" "backup" {
  name                     = "gpadbbackup2023"
  resource_group_name      = azurerm_resource_group.GPA.name
  location                 = azurerm_resource_group.GPA.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
# Create a Storage Account File Share
resource "azurerm_storage_share" "DB-Backup" {
  name                 = "db-backup"
  storage_account_name = azurerm_storage_account.backup.name
  quota                = 50
}