output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_name" {
  description = "RDS instance name"
  value       = module.rds.db_instance_name
}

output "db_username" {
  description = "RDS instance username"
  value       = module.rds.db_instance_username
}

output "db_password_arn" {
  description = "ARN of the secret containing the RDS password"
  value       = module.rds.db_instance_password_arn
}

output "redis_endpoint" {
  description = "ElastiCache cluster endpoint"
  value       = module.elasticache.cache_cluster_endpoint
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.service.arn
}

output "service_discovery_arn" {
  description = "ARN of the service discovery service"
  value       = aws_service_discovery_service.service.arn
} 