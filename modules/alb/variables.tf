variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ALB"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
