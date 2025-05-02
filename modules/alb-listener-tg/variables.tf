variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}


variable "subnets" {
  description = "The subnets to attach the ALB to"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ID of the security group for the ALB"
  type        = string
}