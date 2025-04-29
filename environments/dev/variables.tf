variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
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
  description = "ECS Cluster name (without environment prefix)"
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