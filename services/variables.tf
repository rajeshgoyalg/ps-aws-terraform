variable "environment" {
  description = "Environment name (e.g., dev, prod)"
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

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access the resources"
  type        = list(string)
}

variable "cache_name" {
  description = "Name of the ElastiCache cluster"
  type        = string
}

variable "cache_node_type" {
  description = "ElastiCache node type"
  type        = string
}

variable "cache_subnet_group_name" {
  description = "Name of the cache subnet group"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "cpu" {
  description = "CPU units for the container"
  type        = number
}

variable "memory" {
  description = "Memory for the container in MiB"
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

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 