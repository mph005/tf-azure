variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "myproject"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for VM access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "MyProject"
  }
} 