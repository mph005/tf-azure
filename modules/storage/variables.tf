variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "account_tier" {
  description = "The performance tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "The replication type for the storage account"
  type        = string
  default     = "LRS"
}

variable "blob_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 7
}

variable "containers" {
  description = "Map of container names to container properties"
  type = map(object({
    access_type = string
  }))
  default = {
    "data" = {
      access_type = "private"
    }
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 