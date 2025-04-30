variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "cache_name" {
  description = "Name of the ElastiCache cluster"
  type        = string
}

variable "cache_node_type" {
  description = "Instance type for the ElastiCache nodes"
  type        = string
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

variable "subnet_ids" {
  description = "List of subnet IDs for the ElastiCache cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access the ElastiCache cluster"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 