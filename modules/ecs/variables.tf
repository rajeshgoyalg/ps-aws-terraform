variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "service_name" {
  description = "Name of the service to deploy"
  type        = string
}

variable "container_port" {
  description = "Port on which the container is listening"
  type        = number
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
}

variable "cpu" {
  description = "Number of cpu units used by the task"
  type        = number
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task"
  type        = number
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "region" {
  description = "AWS region"
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
  description = "ARN of the secret containing the database password"
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

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "fargate_capacity_providers" {
  description = "Map of Fargate capacity providers"
  type        = map(any)
  default     = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}

variable "environment_vars" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "image_tag" {
  description = "Tag of the container image to use"
  type        = string
  default     = "latest"
}
