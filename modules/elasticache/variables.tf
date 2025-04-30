variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "cache_name" {
  description = "Name of the cache cluster"
  type        = string
}

variable "cache_node_type" {
  description = "Instance type for the cache nodes"
  type        = string
  default     = "cache.t3.micro"
}

variable "node_type" {
  description = "Instance type for the cache nodes"
  type        = string
  default     = "cache.t3.micro"
}

variable "subnet_group_name" {
  description = "Name of the subnet group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access the cache"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 