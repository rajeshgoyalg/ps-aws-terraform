output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "List of private subnet IDs"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "List of public subnet IDs"
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "The URL of the ECR repository"
}

output "ecr_repository_arn" {
  value       = module.ecr.repository_arn
  description = "The ARN of the ECR repository"
}