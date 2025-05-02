# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = module.vpc.private_route_table_ids
}

# output "container_definition" {
#   description = "The name of the container definition"
#   value       = module.ngnixdemos-hello.container_definition
# }

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_arn
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.new_alb.alb_arn
}

output "alb_security_group_id" {
  description = "ID of the security group for the ALB"
  value       = module.new_alb.alb_security_group_id
}

# ALB Outputs
# output "alb_arn" {
#   description = "ARN of the ALB"
#   value       = module.alb.alb_arn
# }

# output "alb_dns_name" {
#   description = "DNS name of the ALB"
#   value       = module.alb.alb_dns_name
# }

# output "alb_zone_id" {
#   description = "Zone ID of the ALB"
#   value       = module.alb.alb_zone_id
# }

# output "alb_target_group_arn" {
#   description = "ARN of the default target group"
#   value       = module.alb.target_group_arn
# }

# ECR Outputs
# output "ecr_repository_url" {
#   description = "URL of the ECR repository"
#   value       = module.ecr.repository_url
# }

# ECS Outputs
# output "ecs_cluster_id" {
#   description = "ID of the ECS cluster"
#   value       = module.ecs_cluster.cluster_id
# }

# output "ecs_cluster_name" {
#   description = "Name of the ECS cluster"
#   value       = module.ecs_cluster.cluster_name
# }

# output "ecs_service_task_definition_arn" {
#   description = "ARN of the ECS service task definition"
#   value       = module.ecs_service.task_definition_arn
# }

# output "ecs_service_task_execution_role_arn" {
#   description = "ARN of the ECS service task execution role"
#   value       = module.ecs_service.task_execution_role_arn
# }

# RDS Outputs
# output "rds_endpoint" {
#   description = "Endpoint of the RDS instance"
#   value       = module.rds.db_instance_endpoint
# }

# ElastiCache Outputs
# output "redis_endpoint" {
#   description = "Endpoint of the Redis cluster"
#   value       = module.elasticache.redis_endpoint
# } 