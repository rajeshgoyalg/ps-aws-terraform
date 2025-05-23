variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "environment" {
  description = "The deployment environment (e.g., prod, dev, staging)"
  type        = string
}

variable "cluster_arn" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the security group for the ALB"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}