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
    # cache_node_type   = string
    fargate_capacity_providers = map(object({
      default_capacity_provider_strategy = object({
        weight = number
      })
    }))
  }))
}

# vpc variables
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
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

# variable "ingress_rules" {
#   description = "List of ingress rules for the security group"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#     description = string
#   }))
#   default = []
# }

# variable "ingress_rules" {
#   description = "List of ingress rules for the security group"
#   type        = list(string)
# }

# variable "egress_rules" {
#   description = "List of egress rules for the security group"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#     description = string
#   }))
#   default = []
# }

# variable "egress_rules" {
#   description = "List of egress rules for the security group"
#   type        = list(string)
# }

# variable "ingress_with_cidr_blocks" {
#   description = "List of ingress rules with CIDR blocks for the security group"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = string
#     description = string
#   }))
#   default = []
# }

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

# variable "certificate_arn" {
#   description = "ARN of the ACM certificate for HTTPS"
#   type        = string
#   default     = ""
# }

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository."
  type        = string
}

variable "repository_image_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository."
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
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

variable "capacity_provider_weights" {
  description = "Weightages for FARGATE and FARGATE_SPOT capacity providers (must sum to 100)"
  type = object({
    fargate      = number
    fargate_spot = number
  })
  default = {
    fargate      = 50
    fargate_spot = 50
  }

  validation {
    condition     = var.capacity_provider_weights.fargate >= 0 && var.capacity_provider_weights.fargate_spot >= 0
    error_message = "Capacity provider weights must be non-negative."
  }

  validation {
    condition     = var.capacity_provider_weights.fargate + var.capacity_provider_weights.fargate_spot == 100
    error_message = "Capacity provider weights must sum to 100."
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

variable "create_lifecycle_policy" {
  description = "Indicates whether a lifecycle policy should be created for the repository."
  type        = bool
  default     = false
}

variable "image_retention_count" {
  description = "Number of images to keep in the repository"
  type        = number
  default     = 1000
}

variable "repository_encryption_type" {
  description = "The encryption type for the repository."
  type        = string
  default     = "AES256"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}