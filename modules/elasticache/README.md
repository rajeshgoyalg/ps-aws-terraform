# ElastiCache Module

This module creates ElastiCache clusters with security groups and backup configurations.

## Features

- Redis clusters
- Security groups
- Automated backups
- Parameter groups
- Subnet groups
- Maintenance windows

## Usage

```hcl
module "elasticache" {
  source = "./modules/elasticache"

  environment = var.environment
  cache_name = var.cache_name
  node_type = var.node_type
  subnet_group_name = module.vpc.elasticache_subnet_group_name
  vpc_id = module.vpc.vpc_id
  allowed_security_groups = [module.ecs.ecs_tasks_sg_id]
  tags = var.tags
}
```

## Outputs

- `cache_cluster_endpoint`: The endpoint of the ElastiCache cluster
- `cache_cluster_id`: The ID of the ElastiCache cluster
- `cache_security_group_id`: The ID of the ElastiCache security group
- `cache_subnet_group_name`: The name of the ElastiCache subnet group 