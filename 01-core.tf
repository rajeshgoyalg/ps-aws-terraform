module "vpc" {
  source = "./modules/vpc"

  environment     = var.environment
  region          = var.region
  vpc_name        = var.vpc_name
  cidr            = local.env_config.cidr
  azs             = var.azs
  public_subnets  = local.env_config.public_subnets
  private_subnets = local.env_config.private_subnets
  tags            = merge(var.tags, { Environment = var.environment })
}

module "alb" {
  source             = "./modules/alb"

  environment        = var.environment
  alb_name           = var.alb_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  tags               = merge(var.tags, { Environment = var.environment })
}

module "ecr" {
  source              = "./modules/ecr"
  
  environment         = var.environment
  repository_name     = var.repository_name
  image_tag_mutability = "MUTABLE"
  scan_on_push        = true
  encryption_type     = "AES256"
  tags                = merge(var.tags, { Environment = var.environment })
  create_lifecycle_policy = var.create_lifecycle_policy
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  environment = var.environment
  cluster_name = var.cluster_name
  fargate_capacity_providers = local.env_config.fargate_capacity_providers
  vpc_id = module.vpc.vpc_id
  tags = merge(var.tags, { Environment = var.environment })
} 