# RDS Module

This module creates RDS instances with security groups and backup configurations.

## Features

- RDS instances
- Security groups
- Multi-AZ deployment
- Automated backups
- Parameter groups
- Subnet groups

## Usage

```hcl
module "rds" {
  source = "./modules/rds"

  environment = var.environment
  db_name = var.db_name
  db_username = var.db_username
  instance_class = var.instance_class
  db_subnet_group_name = module.vpc.db_subnet_group_name
  vpc_id = module.vpc.vpc_id
  allowed_security_groups = [module.ecs.ecs_tasks_sg_id]
  tags = var.tags
}
```

## Outputs

- `db_instance_endpoint`: The endpoint of the RDS instance
- `db_instance_name`: The name of the RDS instance
- `db_instance_username`: The username of the RDS instance
- `db_instance_password_arn`: The ARN of the secret containing the RDS password
- `db_security_group_id`: The ID of the RDS security group 