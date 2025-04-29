module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.environment}-${var.vpc_name}"
  cidr = var.cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.vpc_name}"
  })
}