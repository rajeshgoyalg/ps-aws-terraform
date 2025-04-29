module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name               = "${var.environment}-${var.alb_name}"
  vpc_id             = var.vpc_id
  subnets            = var.private_subnet_ids
  internal           = true

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.environment}-${var.alb_name}"
  })
}
