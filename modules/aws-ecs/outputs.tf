output "service_name" {
  description = "Name of the ECS service"
  value       = module.ecs_service.name
}

output "security_group_id" {
  description = "Security group ID of the ECS service"
  value       = aws_security_group.ecs_service.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}