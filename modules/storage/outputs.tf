output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.storage.id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "container_names" {
  description = "The names of the storage containers"
  value       = [for container in azurerm_storage_container.container : container.name]
} 