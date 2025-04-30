terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# RDS Module
module "rds" {
  source = "../modules/rds"

  environment        = var.environment
  db_name           = var.db_name
  db_username       = var.db_username
  db_instance_class = var.db_instance_class
  db_subnet_group_name = var.db_subnet_group_name
  vpc_id            = var.vpc_id
  allowed_security_groups = var.allowed_security_groups
  tags              = var.tags
}

# ElastiCache Module
# module "elasticache" {
#   source = "../modules/elasticache"

#   environment        = var.environment
#   cache_name         = var.cache_name
#   node_type          = var.cache_node_type
#   subnet_group_name  = var.cache_subnet_group_name
#   vpc_id            = var.vpc_id
#   allowed_security_groups = var.allowed_security_groups
#   tags              = var.tags
# }

# ECS Service Module
module "ecs_service" {
  source = "../modules/ecs"

  environment        = var.environment
  region            = var.region
  cluster_name      = var.cluster_name
  service_name      = var.service_name
  container_port    = var.container_port
  cpu              = var.cpu
  memory           = var.memory
  desired_count    = var.desired_count
  vpc_id           = var.vpc_id
  ecr_repository_url = var.ecr_repository_url
  db_endpoint      = module.rds.db_instance_endpoint
  db_name          = var.db_name
  db_username      = var.db_username
  db_password_arn  = module.rds.db_instance_password_arn
  # redis_endpoint   = module.elasticache.cache_cluster_endpoint
  tags             = var.tags
} 