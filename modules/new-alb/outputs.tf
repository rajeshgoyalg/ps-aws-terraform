output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.alb.arn
}

output "alb_security_group_id" {
  description = "IDs of the security groups for the ALB"
  value       = module.alb.security_group_id
}
