variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "target_groups" {
  description = "List of target groups to create"
  type = list(object({
    name             = string
    backend_protocol = string
    backend_port     = number
    target_type      = string
    health_check = object({
      enabled             = bool
      interval            = number
      path                = string
      port                = string
      healthy_threshold   = number
      unhealthy_threshold = number
      timeout             = number
      protocol            = string
      matcher             = string
    })
  }))
  default = []
}
