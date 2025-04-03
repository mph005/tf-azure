terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate12345prod"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.project_name}-rg"
  location = var.location

  tags = var.tags
}

module "networking" {
  source = "../../modules/networking"

  vnet_name           = "${var.environment}-${var.project_name}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = ["10.2.0.0/16"]
  subnets = {
    "app"     = "10.2.1.0/24"
    "data"    = "10.2.2.0/24"
    "private" = "10.2.3.0/24"
    "gateway" = "10.2.4.0/24"
  }

  tags = var.tags
}

module "storage" {
  source = "../../modules/storage"

  storage_account_name = "${var.environment}${var.project_name}sa"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  account_tier         = "Standard"
  replication_type     = "GRS"

  containers = {
    "data" = {
      access_type = "private"
    }
    "logs" = {
      access_type = "private"
    }
    "backups" = {
      access_type = "private"
    }
  }

  blob_retention_days = 30

  tags = var.tags
}

module "app_vms" {
  source = "../../modules/compute"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = module.networking.subnet_ids["app"]

  virtual_machines = {
    "${var.environment}-app-vm-1" = {
      size           = "Standard_D2s_v3"
      admin_username = "adminuser"
      ssh_key_path   = var.ssh_public_key_path
      os_disk_type   = "Premium_LRS"
      public_ip      = true
      image = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "20.04-LTS"
        version   = "latest"
      }
    },
    "${var.environment}-app-vm-2" = {
      size           = "Standard_D2s_v3"
      admin_username = "adminuser"
      ssh_key_path   = var.ssh_public_key_path
      os_disk_type   = "Premium_LRS"
      public_ip      = true
      image = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "20.04-LTS"
        version   = "latest"
      }
    },
    "${var.environment}-app-vm-3" = {
      size           = "Standard_D2s_v3"
      admin_username = "adminuser"
      ssh_key_path   = var.ssh_public_key_path
      os_disk_type   = "Premium_LRS"
      public_ip      = true
      image = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "20.04-LTS"
        version   = "latest"
      }
    }
  }

  tags = var.tags
} 