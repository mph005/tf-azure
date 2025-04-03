terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate12345dev"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
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
  address_space       = ["10.0.0.0/16"]
  subnets = {
    "app"     = "10.0.1.0/24"
    "data"    = "10.0.2.0/24"
    "private" = "10.0.3.0/24"
  }

  tags = var.tags
}

module "storage" {
  source = "../../modules/storage"

  storage_account_name = "${var.environment}${var.project_name}sa"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location

  containers = {
    "data" = {
      access_type = "private"
    }
    "logs" = {
      access_type = "private"
    }
  }

  tags = var.tags
}

module "app_vm" {
  source = "../../modules/compute"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = module.networking.subnet_ids["app"]

  virtual_machines = {
    "${var.environment}-app-vm" = {
      size           = "Standard_B2s"
      admin_username = "adminuser"
      ssh_key_path   = var.ssh_public_key_path
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

  tags = var.tags
} 