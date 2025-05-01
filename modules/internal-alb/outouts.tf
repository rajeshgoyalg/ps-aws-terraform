output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.dns_name
}

output "listener_arn" {
  description = "ARN of the ALB listener"
  value       = module.alb.listeners[0].arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.alb.target_groups[0].arn
}

# output "security_group_id" {
#   description = "ID of the ALB security group"
#   value       = module.alb_sg.security_group_id
# }