variable "environment" {
  type        = string
  description = "The environment for the ECS service (e.g., dev, prod)."
}

variable "service_name" {
  type        = string
  description = "The name of the ECS service and task definition."
}

variable "ecs_cluster_arn" {
  type        = string
  description = "The ARN of the ECS cluster."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS tasks."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB."
}

variable "region" {
  type        = string
  description = "AWS region for the ECS service."
  default     = "us-east-1"
}

variable "container_image" {
  type        = string
  description = "The container image to use (e.g., nginx:latest)."
}

variable "container_port" {
  type        = number
  description = "The port the container listens on."
  default     = 80
}

variable "task_cpu" {
  type        = string
  description = "The CPU units for the task (e.g., 256, 512)."
  default     = "256"
}

variable "task_memory" {
  type        = string
  description = "The memory for the task in MiB (e.g., 512, 1024)."
  default     = "512"
}

variable "desired_count" {
  type        = number
  description = "The desired number of tasks to run."
  default     = 2
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain CloudWatch logs."
  default     = 30
}

variable "health_check_path" {
  type        = string
  description = "The path for the ALB health check."
  default     = "/"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources."
  default     = {}
}