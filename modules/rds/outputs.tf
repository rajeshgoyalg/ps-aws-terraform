output "db_instance_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_name" {
  description = "The name of the RDS instance"
  value       = aws_db_instance.main.db_name
}

output "db_instance_username" {
  description = "The username of the RDS instance"
  value       = aws_db_instance.main.username
}

output "db_instance_password_arn" {
  description = "The ARN of the secret containing the RDS password"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "db_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.db.id
} 