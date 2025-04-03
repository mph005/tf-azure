output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.networking.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = module.networking.subnet_ids
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.storage.storage_account_name
}

output "vm_public_ips" {
  description = "The public IP addresses of the virtual machines"
  value       = module.app_vm.vm_public_ips
} 