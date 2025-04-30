locals {
  env_config = var.environments[var.environment]
  
  core_infrastructure = [
    module.vpc,
    module.alb,
    module.ecr,
    module.ecs_cluster
  ]
  
  service_infrastructure = [
    module.rds,
    module.elasticache,
    module.ecs_service
  ]
} 