module "ecs_service" {
  source = "../../modules/aws-ecs"

  environment            = var.environment
  service_name           = "demo-service2"
  cluster_id             = var.cluster_id
  desired_count          = var.desired_count
  cpu                    = var.cpu
  memory                 = var.memory
  container_image        = var.container_image
  container_port         = 4000
  private_subnets        = var.private_subnets
  vpc_id                 = var.vpc_id
  vpc_cidr_block         = var.vpc_cidr_block
  region                 = var.region
  tags                   = var.tags
  service_security_groups = var.service_security_groups
}