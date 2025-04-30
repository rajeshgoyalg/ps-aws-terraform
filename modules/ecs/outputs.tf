output "cluster_id" {
  description = "The ID of the ECS cluster"
  value       = data.aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = var.cluster_name
}

output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = data.aws_ecs_cluster.main.arn
}

output "ecs_tasks_sg_id" {
  description = "The ID of the ECS tasks security group"
  value       = var.create_security_group ? aws_security_group.ecs_tasks[0].id : var.ecs_tasks_sg_id
}

output "task_definition_arn" {
  description = "The ARN of the task definition"
  value       = aws_ecs_task_definition.service.arn
}

output "task_execution_role_arn" {
  description = "The ARN of the task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}
