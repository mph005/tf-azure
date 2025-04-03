resource "azurerm_network_interface" "nic" {
  for_each = var.virtual_machines

  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_ip ? azurerm_public_ip.pip[each.key].id : null
  }

  tags = var.tags
}

resource "azurerm_public_ip" "pip" {
  for_each = {
    for vm_name, vm in var.virtual_machines : vm_name => vm if vm.public_ip
  }

  name                = "${each.key}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.virtual_machines

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = file(each.value.ssh_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = each.value.os_disk_type
  }

  source_image_reference {
    publisher = each.value.image.publisher
    offer     = each.value.image.offer
    sku       = each.value.image.sku
    version   = each.value.image.version
  }

  tags = var.tags
} 