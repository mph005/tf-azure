variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where VMs will be connected"
  type        = string
}

variable "virtual_machines" {
  description = "Map of virtual machine names to their configuration"
  type = map(object({
    size           = string
    admin_username = string
    ssh_key_path   = string
    os_disk_type   = string
    public_ip      = bool
    image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
  }))
  default = {
    "vm1" = {
      size           = "Standard_B2s"
      admin_username = "adminuser"
      ssh_key_path   = "~/.ssh/id_rsa.pub"
      os_disk_type   = "Standard_LRS"
      public_ip      = true
      image = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
      }
    }
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 