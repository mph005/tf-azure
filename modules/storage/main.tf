resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = var.blob_retention_days
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "container" {
  for_each = var.containers

  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = each.value.access_type
} 