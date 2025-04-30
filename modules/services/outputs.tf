output "demoapp1_target_group_arn" {
  description = "ARN of the demoapp1 target group"
  value       = module.demoapp1.target_group_arn
}

output "demoapp2_target_group_arn" {
  description = "ARN of the demoapp2 target group"
  value       = module.demoapp2.target_group_arn
}

output "demoapp1_service_discovery_arn" {
  description = "ARN of the demoapp1 service discovery service"
  value       = module.demoapp1.service_discovery_arn
}

output "demoapp2_service_discovery_arn" {
  description = "ARN of the demoapp2 service discovery service"
  value       = module.demoapp2.service_discovery_arn
}