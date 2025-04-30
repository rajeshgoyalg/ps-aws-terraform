# Commented out until RDS module is fully configured
# output "db_instance_endpoint" {
#   description = "Endpoint of the RDS instance"
#   value       = module.db.db_instance_endpoint
# }
# 
# output "db_instance_name" {
#   description = "Name of the RDS instance"
#   value       = module.db.db_instance_name
# }
# 
# output "db_instance_username" {
#   description = "Username of the RDS instance"
#   value       = module.db.db_instance_username
# }
# 
# # Password should be managed through Secrets Manager or other secure means
# # output "db_instance_password" {
# #   description = "Password of the RDS instance (sensitive)"
# #   value       = module.db.db_instance_password
# #   sensitive   = true
# # }

output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = "${var.environment}-${var.db_name}.${data.aws_region.current.name}.rds.amazonaws.com"
}

output "db_instance_name" {
  description = "Name of the RDS instance"
  value       = var.db_name
}

output "db_instance_username" {
  description = "Username of the RDS instance"
  value       = var.db_username
}

output "db_master_user_secret_arn" {
  description = "ARN of the master user secret"
  value       = module.db.db_instance_master_user_secret_arn
}

output "db_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
} 