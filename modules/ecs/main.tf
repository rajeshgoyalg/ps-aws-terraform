module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = ">= 5.0.0"

  cluster_name  = "${var.environment}-${var.cluster_name}"
  fargate_capacity_providers = var.fargate_capacity_providers
  tags         = merge(var.tags, { Environment = var.environment, Name = "${var.environment}-${var.cluster_name}" })
}
