# ECS Module

This module creates an ECS cluster with Fargate capacity providers and service definitions.

## Features

- ECS cluster
- Fargate capacity providers
- Task execution role
- Service discovery
- Auto-scaling
- CloudWatch log groups
- Service templates

## Usage

```hcl
module "ecs" {
  source = "./modules/ecs"

  environment = var.environment
  cluster_name = var.cluster_name
  fargate_capacity_providers = var.fargate_capacity_providers
  tags = var.tags

  vpc_id = module.vpc.vpc_id
  ecr_repository_url = module.ecr.repository_url
  region = var.region

  db_endpoint = module.rds.db_endpoint
  db_name = module.rds.db_name
  db_username = module.rds.db_username
  db_password_arn = module.rds.db_password_arn
  redis_endpoint = module.elasticache.redis_endpoint
}
```

## Outputs

- `cluster_id`: The ID of the ECS cluster
- `cluster_arn`: The ARN of the ECS cluster
- `ecs_tasks_sg_id`: The ID of the ECS tasks security group
- `service_discovery_namespace_id`: The ID of the service discovery namespace 