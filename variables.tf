variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
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

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository (without environment prefix)"
  type        = string
}

variable "create_lifecycle_policy" {
  description = "Indicates whether a lifecycle policy should be created for the repository."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "fargate_capacity_providers" {
  description = "Map of capacity providers and their default strategies for the ECS cluster."
  type = map(object({
    default_capacity_provider_strategy = object({
      weight = number
    })
  }))
  default = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
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

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "shared_db"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "cache_name" {
  description = "Name of the cache cluster"
  type        = string
  default     = "shared_cache"
}

variable "cache_node_type" {
  description = "Instance type for the cache nodes"
  type        = string
  default     = "cache.t3.micro"
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "container_port" {
  description = "Port on which the container will listen"
  type        = number
  default     = 8080
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
  default     = 2
} 