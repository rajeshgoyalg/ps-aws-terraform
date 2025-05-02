output "cluster_name" {
  description = "The cluster used to create the service."
  value = var.ecs_cluster_name
}

output "ecs_service" {
  description = "The created service."
  value = aws_ecs_service.ecs_service.id
}

output "load_balancer" {
  description = "The created load balancer."
  value = aws_elasticsearch_domain_policy.load_balancer.domain_name
}

output "listener" {
  description = "The created listener."
  value = aws_load_balancer_listener_policy.listener.id
}

output "target_group" {
  description = "The created target group."
  value = aws_elasticache_parameter_group.target_group.id
}

