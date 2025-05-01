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

# VPC Module
module "vpc" {
  source = "../modules/vpc"

  environment     = var.environment
  region          = var.region
  vpc_name        = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  tags            = var.tags
}

# ALB Module
module "alb" {
  source = "../modules/alb"

  environment        = var.environment
  alb_name           = var.alb_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  certificate_arn    = var.certificate_arn
  tags               = var.tags
}

# ECR Module
module "ecr" {
  source = "../modules/ecr"

  environment     = var.environment
  repository_name = var.repository_name
  tags            = var.tags
}

# ECS Cluster Module
module "ecs_cluster" {
  source = "../modules/ecs-cluster"

  environment                = var.environment
  region                     = var.region
  cluster_name               = var.cluster_name
  vpc_id                     = module.vpc.vpc_id
  fargate_capacity_providers = var.fargate_capacity_providers
  tags                       = var.tags
}

module "ecs_service" {
  source = "./modules/ecs"

  environment           = var.environment
  region                = var.region
  vpc_id                = module.vpc.vpc_id
  ecr_repository_url    = module.ecr.repository_url
  cluster_name          = var.cluster_name
  service_name          = var.service_name
  container_port        = var.container_port
  cpu                   = var.cpu
  memory                = var.memory
  desired_count         = var.desired_count
  db_endpoint           = module.rds.db_instance_endpoint
  db_name               = var.db_name
  db_username           = var.db_username
  db_password_arn       = module.rds.db_master_user_secret_arn
  private_subnets       = module.vpc.private_subnet_ids
  alb_security_group_id = module.alb.security_group_id
  target_group_arn      = module.alb.target_group_arn
  create_security_group = false
  ecs_tasks_sg_id       = module.ecs_cluster.ecs_tasks_sg_id
  tags                  = var.tags
}