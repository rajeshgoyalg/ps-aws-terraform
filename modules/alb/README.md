# ALB Module

This module creates an Application Load Balancer with security groups and listeners.

## Features

- Application Load Balancer
- Security groups for ALB
- HTTP and HTTPS listeners
- Target groups
- Health checks

## Usage

```hcl
module "alb" {
  source             = "./modules/alb"
  environment        = var.environment
  alb_name           = var.alb_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  tags               = var.tags
}
```

## Outputs

- `alb_arn`: The ARN of the ALB
- `alb_dns_name`: The DNS name of the ALB
- `alb_zone_id`: The zone ID of the ALB
- `target_group_arn`: The ARN of the default target group
- `alb_security_group_id`: The ID of the ALB security group
