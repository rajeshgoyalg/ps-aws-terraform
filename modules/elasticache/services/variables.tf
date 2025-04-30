variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "engine" {
  description = "Cache engine type"
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "Cache engine version"
  type        = string
  default     = "6.2"
}

variable "node_type" {
  description = "Cache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

variable "port" {
  description = "Cache port"
  type        = number
  default     = 6379
}

variable "subnet_group_name" {
  description = "Name of the subnet group"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "mon:03:00-mon:04:00"
}

variable "snapshot_window" {
  description = "Snapshot window"
  type        = string
  default     = "04:00-05:00"
}

variable "snapshot_retention_limit" {
  description = "Number of days to retain snapshots"
  type        = number
  default     = 7
}

variable "parameter_group_name" {
  description = "Name of the parameter group"
  type        = string
  default     = "default.redis6.x"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access the cache"
  type        = list(string)
} 