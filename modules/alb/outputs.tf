output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.alb.lb_arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.lb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = module.alb.lb_zone_id
}

output "target_group_arn" {
  description = "ARN of the default target group"
  value       = module.alb.target_group_arns[0]
}

output "security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}
