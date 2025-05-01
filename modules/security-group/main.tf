module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.environment}-${var.name}-sg"
  description = "${var.environment} - ${var.description}"
  vpc_id      = var.vpc_id

  ingress_rules = var.ingress_rules
  ingress_cidr_blocks = var.ingress_cidr_blocks
  # ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_rules  = var.egress_rules
  egress_cidr_blocks = var.egress_cidr_blocks
  
  tags = merge(var.tags, {
    Name = "${var.environment}-${var.name}-sg"
  })
}