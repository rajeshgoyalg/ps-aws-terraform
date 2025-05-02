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
  source = "./modules/vpc"

  environment     = var.environment
  region          = var.region
  vpc_name        = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags            = var.tags
}

# # Security Group Module - vpc-endpoints-sg
# module "vpc_endpoints_security_group" {
#   source = "./modules/security-group"

#   environment     = var.environment
#   vpc_id          = module.vpc.vpc_id

#   name          = "vpc-endpoints"
#   description   = "VPC endpoints"

#   ingress_rules = ["https-443-tcp"]
#   ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

#   egress_rules  = ["https-443-tcp"]
#   egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  
#   tags            = var.tags
# }

# # VPC Endpoints
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id             = module.vpc.vpc_id
#   service_name       = "com.amazonaws.${var.region}.ecr.api"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = module.vpc.private_subnet_ids
#   security_group_ids = [module.vpc_endpoints_security_group.security_group_id]
  
#   private_dns_enabled = true

#   tags = merge(var.tags, {
#     Name = "${var.environment}-ecr-api"
#   })
# }

# # VPC Endpoints
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id             = module.vpc.vpc_id
#   service_name       = "com.amazonaws.${var.region}.ecr.dkr"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = module.vpc.private_subnet_ids
#   security_group_ids = [module.vpc_endpoints_security_group.security_group_id]
  
#   private_dns_enabled = true

#   tags = merge(var.tags, {
#     Name = "${var.environment}-ecr-dkr"
#   })
# }

# # VPC Endpoints
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = module.vpc.private_route_table_ids

#   tags = merge(var.tags, {
#     Name = "${var.environment}-s3"
#   })
# }

# # ECR Module
# module "ecr" {
#   source = "./modules/ecr"

#   environment                   = var.environment
#   repository_name               = var.repository_name
#   image_tag_mutability          = var.image_tag_mutability
#   repository_image_scan_on_push = var.repository_image_scan_on_push
#   repository_encryption_type    = var.repository_encryption_type
#   create_lifecycle_policy       = var.create_lifecycle_policy
#   image_retention_count         = var.image_retention_count
#   tags                          = var.tags
# }

# ECS Cluster Module
module "ecs_cluster" {
  source = "./modules/aws-ecs-cluster"

  environment               = var.environment
  cluster_name              = var.cluster_name
  capacity_provider_weights = var.capacity_provider_weights
  
  tags                      = var.tags
}

# New ALB Module
module "new_alb" {
  source = "./modules/new-alb"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  subnets     = module.vpc.public_subnet_ids
  alb_name    = var.alb_name
  tags        = var.tags
}

# module "ngnixdemos-hello" {
#   source = "./modules/ecs-container-definition"

#   environment = var.environment
#   tags        = var.tags
# }

module "ecs-task-definition" {
  source = "./modules/ecs-task-definition"

  environment = var.environment
  
  cluster_arn = module.ecs_cluster.ecs_cluster_arn
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  alb_arn = module.new_alb.alb_arn
  alb_security_group_id = module.new_alb.alb_security_group_id
  
  tags        = var.tags
}

# ALB Listener and Target Group Module
# module "alb_listener_tg" {
#   source = "./modules/alb-listener-tg"

#   environment = var.environment

#   alb_name = var.alb_name
#   vpc_id = module.vpc.vpc_id
#   subnets = module.vpc.public_subnet_ids
#   alb_security_group_id = module.new_alb.security_group_id
#   tags = var.tags
# }

# ECS Service Module
# module "ecs_service" {
#   source = "./modules/aws-ecs"

#   environment = var.environment

#   subnet_ids = module.vpc.public_subnet_ids
#   cluster_arn = module.ecs_cluster.ecs_cluster_arn
#   target_group_arn = module.new_alb.target_group_arn
#   alb_security_group_id = module.new_alb.security_group_id
#   tags        = var.tags

# }

# # Security Group Module - demo_service1_sg
# module "demo_service1_security_group" {
#   source = "./modules/security-group"

#   environment     = var.environment
#   vpc_id          = module.vpc.vpc_id

#   name          = "demo_service1"
#   description   = "demo service1"

#   ingress_rules = ["https-443-tcp"]
#   ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

#   egress_rules  = ["https-443-tcp"]
#   egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  
#   tags            = var.tags
# }

# module "demo-service1" {
#   source = "./modules/aws-ecs"

#   environment            = var.environment
#   service_name           = "demo-service1"
#   cluster_id             = module.ecs_cluster.cluster_id
#   cpu                    = 256
#   memory                 = 512
#   container_image        = "nginx:latest"
#   container_port         = 3000
#   private_subnets        = var.private_subnets
#   vpc_id                 = module.vpc.vpc_id
#   vpc_cidr_block         = var.vpc_cidr_block
#   region                 = var.region
#   service_security_groups = module.demo_service1_security_group.security_group_id
#   launch_type = "FARGATE_SPOT"

#   tags                   = var.tags
# }

# # Security Group Module - demo_service2_sg
# module "demo_service2_security_group" {
#   source = "./modules/security-group"

#   environment     = var.environment
#   vpc_id          = module.vpc.vpc_id

#   name          = "demo_service2"
#   description   = "demo service2"

#   ingress_rules = ["https-443-tcp"]
#   ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

#   egress_rules  = ["https-443-tcp"]
#   egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  
#   tags            = var.tags
# }

# module "demo-service2" {
#   source = "./modules/aws-ecs"

#   environment            = var.environment
#   service_name           = "demo-service2"
#   cluster_id             = module.ecs_cluster.cluster_id
#   cpu                    = 256
#   memory                 = 512
#   container_image        = "nginx:latest"
#   container_port         = 4000
#   private_subnets        = var.private_subnets
#   vpc_id                 = module.vpc.vpc_id
#   vpc_cidr_block         = var.vpc_cidr_block
#   region                 = var.region
#   service_security_groups = module.demo_service2_security_group.security_group_id
#   launch_type = "FARGATE_SPOT"

#   tags                   = var.tags
# }


# Security Group Module - internal alb
# module "internal_alb_security_group" {
#   source = "./modules/security-group"

#   environment     = var.environment
#   vpc_id          = module.vpc.vpc_id

#   # vpc endpoints sg
#   name          = "internal-alb"
#   description   = "internal alb"

#   ingress_rules = ["http-80-tcp"]
#   ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

#   egress_rules  = ["http-80-tcp"]
#   egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  
#   tags            = var.tags
# }

# ALB Module
# module "alb" {
#   # source = "./modules/alb"
#   source = "./modules/internal-alb"

#   environment        = var.environment
#   alb_name           = var.alb_name
#   vpc_id             = module.vpc.vpc_id
#   vpc_cidr           = var.vpc_cidr
#   private_subnet_ids = module.vpc.private_subnet_ids
#   security_groups    = [module.internal_alb_security_group.security_group_id]

#   tags               = var.tags
# }

# ECS Service Module
# module "ecs_service" {
#   source = "./modules/ecs"

#   environment           = var.environment
#   region                = var.region
#   vpc_id                = module.vpc.vpc_id
#   ecr_repository_url    = module.ecr.repository_url
#   cluster_name          = var.cluster_name
#   service_name          = var.service_name
#   container_port        = var.container_port
#   cpu                   = var.cpu
#   memory                = var.memory
#   desired_count         = var.desired_count
#   db_endpoint           = module.rds.db_instance_endpoint
#   db_name               = var.db_name
#   db_username           = var.db_username
#   db_password_arn       = module.rds.db_master_user_secret_arn
#   private_subnets       = module.vpc.private_subnet_ids
#   alb_security_group_id = module.alb.security_group_id
#   target_group_arn      = module.alb.target_group_arn
#   create_security_group = false
#   ecs_tasks_sg_id       = module.ecs_cluster.ecs_tasks_sg_id
#   tags                  = var.tags
# }

# # Services Infrastructure
# module "rds" {
#   source = "./modules/rds"

#   environment             = var.environment
#   db_name                 = var.db_name
#   db_username             = var.db_username
#   db_instance_class       = var.db_instance_class
#   db_subnet_group_name    = "${var.environment}-db-subnet-group"
#   private_subnet_ids      = module.vpc.private_subnet_ids
#   vpc_id                  = module.vpc.vpc_id
#   allowed_security_groups = [module.ecs_cluster.ecs_tasks_sg_id]
#   tags                    = var.tags
# }

# locals {
#   env_config = var.environments[var.environment]
  
#   core_infrastructure = [
#     module.vpc,
#     module.alb,
#     module.ecr,
#     module.ecs_cluster
#   ]
  
#   service_infrastructure = [
#     module.rds,
#     module.ecs_service
#   ]
# } 