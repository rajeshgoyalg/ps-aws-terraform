output "cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_tasks_sg_id" {
  description = "The ID of the ECS tasks security group"
  value       = aws_security_group.ecs_tasks.id
}

output "service_discovery_namespace_id" {
  description = "The ID of the service discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.ecs.id
}
