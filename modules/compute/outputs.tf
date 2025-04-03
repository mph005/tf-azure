output "vm_ids" {
  description = "The IDs of the virtual machines"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : k => v.id }
}

output "vm_private_ips" {
  description = "The private IP addresses of the virtual machines"
  value       = { for k, v in azurerm_network_interface.nic : k => v.private_ip_address }
}

output "vm_public_ips" {
  description = "The public IP addresses of the virtual machines (if applicable)"
  value       = { for k, v in azurerm_public_ip.pip : k => v.ip_address }
} 