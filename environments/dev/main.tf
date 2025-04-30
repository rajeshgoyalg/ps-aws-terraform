module "vpc" {
  source = "../../modules/vpc"

  environment     = var.environment
  region          = var.region
  vpc_name        = var.vpc_name
  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "alb" {
  source             = "../../modules/alb"
  environment        = var.environment
  alb_name           = var.alb_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  tags               = var.tags
}

module "ecr" {
  source              = "../../modules/ecr"
  environment         = var.environment
  repository_name     = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  scan_on_push        = var.scan_on_push
  encryption_type     = var.encryption_type
  tags                = var.tags
  create_lifecycle_policy = var.create_lifecycle_policy
}


module "ecs_cluster" {
  source                   = "../../modules/ecs"
  environment              = var.environment
  cluster_name             = var.cluster_name
  fargate_capacity_providers = var.fargate_capacity_providers
  tags                    = var.tags
}
