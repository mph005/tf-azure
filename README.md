# Terraform Azure Environment

This repository contains Terraform configurations for managing Azure resources across multiple environments (development, staging, and production).

## Project Structure

```
.
├── modules/               # Reusable Terraform modules
│   ├── networking/        # Networking module (VNet, subnets, NSGs)
│   ├── storage/           # Storage module (Storage accounts and containers)
│   └── compute/           # Compute module (Virtual machines)
│
├── main/                  # Environment-specific configurations
│   ├── dev/               # Development environment
│   ├── staging/           # Staging environment
│   └── prod/              # Production environment
│
└── docs/                  # Documentation
```

## Modules

### Networking Module

The networking module creates:
- Virtual Network
- Subnets
- Network Security Groups
- NSG-Subnet associations

### Storage Module

The storage module creates:
- Storage Account
- Storage Containers
- Configurable retention policies

### Compute Module

The compute module creates:
- Virtual Machines
- Network Interfaces
- Public IPs (optional)

## Environment Configurations

Each environment (dev, staging, prod) has its own configuration with appropriate settings:

- **Development**: Basic infrastructure for development and testing
- **Staging**: Mimics production for pre-release testing
- **Production**: Robust infrastructure with redundancy and higher performance

## Prerequisites

1. Azure CLI installed and configured
2. Terraform CLI installed (v1.0.0+)
3. Storage account for Terraform state (see below)

## Setting Up Remote State Storage

Before using this configuration, you need to create a storage account for Terraform state:

```bash
az group create --name tfstate --location eastus

az storage account create --resource-group tfstate \
  --name tfstate12345dev --sku Standard_LRS \
  --encryption-services blob

az storage account create --resource-group tfstate \
  --name tfstate12345stg --sku Standard_LRS \
  --encryption-services blob

az storage account create --resource-group tfstate \
  --name tfstate12345prod --sku Standard_LRS \
  --encryption-services blob

# Create container in each storage account
for account in tfstate12345dev tfstate12345stg tfstate12345prod; do
  az storage container create --name tfstate \
    --account-name $account
done
```

## Usage

To initialize and apply the Terraform configuration for a specific environment:

```bash
# For development environment
cd main/dev
terraform init
terraform plan
terraform apply

# For staging environment
cd main/staging
terraform init
terraform plan
terraform apply

# For production environment
cd main/prod
terraform init
terraform plan
terraform apply
```

## Security Considerations

- Sensitive data is managed through environment variables or Azure Key Vault
- Network security groups restrict access appropriately
- Storage accounts use private access
- All resources are properly tagged for management and compliance

## Best Practices

This project follows these Terraform best practices:

1. Use of modules for reusable components
2. Remote state management with locking
3. Environment isolation
4. Consistent naming conventions
5. Proper tagging strategy
6. Minimal use of hardcoded values
7. Least privilege principle for access control 