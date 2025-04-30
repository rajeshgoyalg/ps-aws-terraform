variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "container_port" {
  description = "Port on which the container will listen"
  type        = number
}

variable "cpu" {
  description = "CPU units for the container"
  type        = number
}

variable "memory" {
  description = "Memory for the container in MB"
  type        = number
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "ecs_tasks_sg_id" {
  description = "ID of the ECS tasks security group"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "service_discovery_namespace_id" {
  description = "ID of the service discovery namespace"
  type        = string
}

variable "db_endpoint" {
  description = "Endpoint of the RDS instance"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "db_password_arn" {
  description = "ARN of the secret containing the RDS password"
  type        = string
}

variable "redis_endpoint" {
  description = "Endpoint of the Redis cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 