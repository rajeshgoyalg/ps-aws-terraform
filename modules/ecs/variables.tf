variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
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

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
