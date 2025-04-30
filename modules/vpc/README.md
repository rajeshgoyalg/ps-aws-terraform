# VPC Module

This module creates a VPC with public and private subnets across multiple availability zones.

## Features

- VPC with configurable CIDR block
- Public and private subnets
- NAT Gateway for private subnet internet access
- Route tables and associations
- VPC endpoints for AWS services
- Subnet groups for RDS and ElastiCache

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  environment     = var.environment
  region          = var.region
  vpc_name        = var.vpc_name
  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}
```

## Outputs

- `vpc_id`: The ID of the VPC
- `private_subnet_ids`: List of private subnet IDs
- `public_subnet_ids`: List of public subnet IDs
- `db_subnet_group_name`: Name of the DB subnet group
- `elasticache_subnet_group_name`: Name of the ElastiCache subnet group 