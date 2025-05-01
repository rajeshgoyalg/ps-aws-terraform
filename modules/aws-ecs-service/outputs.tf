output "ecs_service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.main.name
}

output "task_definition_arn" {
  description = "The ARN of the ECS task definition."
  value       = aws_ecs_task_definition.main.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = aws_lb.main.dns_name
}