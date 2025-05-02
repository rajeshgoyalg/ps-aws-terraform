# variable "environment" {
#   description = "The deployment environment (e.g., prod, dev, staging)"
#   type        = string
# }

# variable "service_name" {
#   description = "Name of the ECS service"
#   type        = string
# }

# variable "cluster_id" {
#   description = "ID of the ECS cluster"
#   type        = string
# }

# variable "desired_count" {
#   description = "Number of tasks to run"
#   type        = number
#   default     = 1
# }

# variable "launch_type" {
#   description = "Launch type for the ECS service"
#   type        = string
#   default     = "FARGATE_SPOT"
# }

# variable "cpu" {
#   description = "CPU units for the task"
#   type        = number
#   default     = 256
# }

# variable "memory" {
#   description = "Memory (MB) for the task"
#   type        = number
#   default     = 512
# }

# variable "container_image" {
#   description = "Container image to use"
#   type        = string
# }

# variable "container_port" {
#   description = "Port the container listens on"
#   type        = number
# }

# variable "private_subnets" {
#   description = "List of private subnet IDs"
#   type        = list(string)
# }

# variable "vpc_id" {
#   description = "VPC ID"
#   type        = string
# }

# variable "vpc_cidr_block" {
#   description = "VPC CIDR block"
#   type        = list(string)
# }

# variable "region" {
#   description = "AWS region"
#   type        = string
# }

# variable "tags" {
#   description = "Tags to apply to resources"
#   type        = map(string)
# }

# variable "service_security_groups" {
#   description = "List of security group IDs for inter-service communication"
#   type        = list(string)
# }