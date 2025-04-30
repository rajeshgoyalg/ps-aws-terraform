output "cache_cluster_endpoint" {
  description = "The endpoint of the ElastiCache cluster"
  value       = aws_elasticache_cluster.main.cache_nodes[0].address
}

output "cache_cluster_id" {
  description = "The ID of the ElastiCache cluster"
  value       = aws_elasticache_cluster.main.id
}

output "cache_security_group_id" {
  description = "The ID of the ElastiCache security group"
  value       = aws_security_group.cache.id
}

output "cache_subnet_group_name" {
  description = "The name of the ElastiCache subnet group"
  value       = aws_elasticache_subnet_group.main.name
} 