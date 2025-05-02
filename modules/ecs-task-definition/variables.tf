variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "cluster_arn" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "alb_arn" {
  description = "The ARN of the ALB"
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
