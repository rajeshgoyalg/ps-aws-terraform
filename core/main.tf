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

  environment      = var.environment
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
  alb_name          = var.alb_name
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  certificate_arn   = var.certificate_arn
  tags              = var.tags
}

# ECR Module
module "ecr" {
  source = "../modules/ecr"

  environment        = var.environment
  repository_name    = var.repository_name
  tags              = var.tags
}

# ECS Cluster Module
module "ecs_cluster" {
  source = "../modules/ecs-cluster"

  environment        = var.environment
  region            = var.region
  cluster_name      = var.cluster_name
  vpc_id            = module.vpc.vpc_id
  fargate_capacity_providers = var.fargate_capacity_providers
  tags              = var.tags
} 