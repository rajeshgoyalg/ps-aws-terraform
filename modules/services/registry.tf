locals {
  services = {
    demoapp1 = {
      db_instance_class = "db.t3.micro"
      # cache_node_type   = "cache.t3.micro"
      cpu              = 256
      memory           = 512
      max_capacity     = 4
      min_capacity     = 1
      desired_count    = 2
      health_check_path = "/health"
      container_port   = 3000
      host_port       = 3000
      image_tag       = ""
      environment_vars = []
    }
    demoapp2 = {
      db_instance_class = "db.t3.micro"
      # cache_node_type   = "cache.t3.micro"
      cpu              = 256
      memory           = 512
      max_capacity     = 4
      min_capacity     = 1
      desired_count    = 2
      health_check_path = "/health"
      container_port   = 4000
      host_port       = 4000
      image_tag       = "demoapp2"
      environment_vars = [
        {
          name  = "NODE_ENV"
          value = var.environment
        },
        {
          name  = "PORT"
          value = "8080"
        }
      ]
    }
  }
}

module "demoapp1" {
  source = "../service_template"

  environment = var.environment
  service_name = "demoapp1"
  config = local.services.demoapp1

  vpc_id = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  db_subnet_group_name = var.db_subnet_group_name
  elasticache_subnet_group_name = var.elasticache_subnet_group_name
  ecs_cluster_id = var.ecs_cluster_id
  ecs_cluster_name = var.ecs_cluster_name
  ecs_tasks_sg_id = var.ecs_tasks_sg_id
  ecs_task_execution_role_arn = var.ecs_task_execution_role_arn
  service_discovery_namespace_id = var.service_discovery_namespace_id
  ecr_repository_url = var.ecr_repository_url
  region = var.region
  db_username = var.db_username
  tags = var.tags
}

module "demoapp2" {
  source = "../service_template"

  environment = var.environment
  service_name = "demoapp2"
  config = local.services.demoapp2

  vpc_id = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  db_subnet_group_name = var.db_subnet_group_name
  elasticache_subnet_group_name = var.elasticache_subnet_group_name
  ecs_cluster_id = var.ecs_cluster_id
  ecs_cluster_name = var.ecs_cluster_name
  ecs_tasks_sg_id = var.ecs_tasks_sg_id
  ecs_task_execution_role_arn = var.ecs_task_execution_role_arn
  service_discovery_namespace_id = var.service_discovery_namespace_id
  ecr_repository_url = var.ecr_repository_url
  region = var.region
  db_username = var.db_username
  tags = var.tags
}