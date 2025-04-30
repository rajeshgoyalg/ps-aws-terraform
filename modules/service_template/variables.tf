variable "environment" {
  description = "Environment name"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "config" {
  description = "Service configuration"
  type = object({
    db_instance_class = string
    # cache_node_type   = string
    cpu              = number
    memory           = number
    max_capacity     = number
    min_capacity     = number
    desired_count    = number
    health_check_path = string
    container_port   = number
    host_port       = number
    image_tag       = string
    environment_vars = list(object({
      name  = string
      value = string
    }))
  })
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

variable "elasticache_subnet_group_name" {
  description = "Name of the ElastiCache subnet group"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_tasks_sg_id" {
  description = "ECS tasks security group ID"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "service_discovery_namespace_id" {
  description = "Service discovery namespace ID"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 