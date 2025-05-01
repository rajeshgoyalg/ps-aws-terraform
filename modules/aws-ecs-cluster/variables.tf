variable "environment" {
  type        = string
  description = "The environment for the ECS cluster (e.g., dev, prod)."
}

variable "cluster_name" {
  type        = string
  description = "The base name of the ECS cluster (e.g., ecs-cluster)."
  default     = "ecs-cluster"
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

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources."
  default     = {}
}