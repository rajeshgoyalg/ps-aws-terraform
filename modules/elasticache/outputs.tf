# Commented out until elasticache module is fully configured
# output "redis_endpoint" {
#   description = "Endpoint of the Redis cluster"
#   value       = module.cache.cluster_address
# }

# output "cache_cluster_id" {
#   description = "ID of the Redis cluster"
#   value       = module.cache.cluster_id
# }

# output "cache_subnet_group_name" {
#   description = "Name of the cache subnet group"
#   value       = module.cache.subnet_group_name
# }

output "redis_endpoint" {
  description = "Endpoint of the Redis cluster"
  value       = "${var.environment}-${var.cache_name}-cache.cache.amazonaws.com"
}

output "cache_cluster_id" {
  description = "ID of the Redis cluster"
  value       = "${var.environment}-${var.cache_name}-cache"
}

output "cache_subnet_group_name" {
  description = "Name of the cache subnet group"
  value       = var.subnet_group_name
}

output "security_group_id" {
  description = "ID of the Redis security group"
  value       = aws_security_group.cache.id
} 