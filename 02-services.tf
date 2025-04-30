module "rds" {
  source = "./modules/rds"

  environment = var.environment
  db_name = var.db_name
  db_username = var.db_username
  db_instance_class = local.env_config.db_instance_class
  db_subnet_group_name = module.vpc.db_subnet_group_name
  vpc_id = module.vpc.vpc_id
  allowed_security_groups = [module.ecs_cluster.ecs_tasks_sg_id]
  tags = merge(var.tags, { Environment = var.environment })
}

module "elasticache" {
  source = "./modules/elasticache"

  environment = var.environment
  cache_name = var.cache_name
  node_type = local.env_config.cache_node_type
  subnet_group_name = module.vpc.elasticache_subnet_group_name
  vpc_id = module.vpc.vpc_id
  allowed_security_groups = [module.ecs_cluster.ecs_tasks_sg_id]
  tags = merge(var.tags, { Environment = var.environment })
}

module "ecs_service" {
  source = "./modules/ecs-service"

  environment = var.environment
  service_name = var.service_name
  cluster_name = var.cluster_name
  container_port = var.container_port
  cpu = var.cpu
  memory = var.memory
  desired_count = var.desired_count

  ecr_repository_url = module.ecr.repository_url
  region = var.region
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_tasks_sg_id = module.ecs_cluster.ecs_tasks_sg_id
  target_group_arn = module.alb.target_group_arn
  service_discovery_namespace_id = module.ecs_cluster.service_discovery_namespace_id

  db_endpoint = module.rds.db_endpoint
  db_name = module.rds.db_name
  db_username = module.rds.db_username
  db_password_arn = module.rds.db_password_arn
  redis_endpoint = module.elasticache.redis_endpoint

  tags = merge(var.tags, { Environment = var.environment })
} 