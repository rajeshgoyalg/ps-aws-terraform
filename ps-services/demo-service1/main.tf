module "ecs_service" {
  source = "../../modules/aws-ecs"

  environment            = var.environment
  service_name           = "demo-service1"
  cluster_id             = var.cluster_id
  cpu                    = 256
  memory                 = 512
  container_image        = "nginx:latest"
  container_port         = 3000
  private_subnets        = var.private_subnets
  vpc_id                 = var.vpc_id
  vpc_cidr_block         = var.vpc_cidr_block
  region                 = var.region
  tags                   = var.tags
  service_security_groups = var.service_security_groups
  launch_type = "FARGATE_SPOT"
}