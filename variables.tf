variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "environments" {
  description = "Environment-specific configurations"
  type = map(object({
    cidr            = string
    public_subnets  = list(string)
    private_subnets = list(string)
    db_instance_class = string
    cache_node_type   = string
    fargate_capacity_providers = map(object({
      default_capacity_provider_strategy = object({
        weight = number
      })
    }))
  }))
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
  default     = ""
}

variable "fargate_capacity_providers" {
  description = "Map of Fargate capacity providers and their configurations"
  type = map(object({
    default_capacity_provider_strategy = object({
      weight = number
    })
  }))
  default = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 0
      }
    }
  }
}

# RDS Variables
variable "db_instance_class" {
  description = "Instance class for RDS"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

# ElastiCache Variables
variable "cache_node_type" {
  description = "Instance type for ElastiCache"
  type        = string
}

variable "subnet_group_name" {
  description = "Name of the ElastiCache subnet group"
  type        = string
}

variable "cache_name" {
  description = "Name of the cache cluster"
  type        = string
  default     = "shared_cache"
}

# ECS Service Variables
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
  default     = 256
}

variable "memory" {
  description = "Memory for the container in MB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "create_lifecycle_policy" {
  description = "Indicates whether a lifecycle policy should be created for the repository."
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type for the repository."
  type        = string
  default     = "AES256"
}