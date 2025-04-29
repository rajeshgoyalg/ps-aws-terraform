output "repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository"
  value       = module.ecr.repository_arn
}
