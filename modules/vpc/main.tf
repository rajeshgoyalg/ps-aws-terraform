module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.environment}-${var.vpc_name}"
  cidr = var.cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  # Enable DNS hostnames and DNS support
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Enable NAT Gateway for private subnets
  enable_nat_gateway = true
  single_nat_gateway = true

  # Tags for ECS
  private_subnet_tags = {
    "aws:ecs:cluster" = "true"
    "Environment"     = var.environment
    "Tier"            = "private"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.vpc_name}"
  })
}

# resource "aws_security_group" "vpc_endpoints" {
#   name        = "${var.environment}-vpc-endpoints-sg"
#   description = "${var.environment} - Security group for VPC endpoints"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [module.vpc.vpc_cidr_block]
#   }

#   tags = merge(var.tags, {
#     Name = "${var.environment}-vpc-endpoints-sg"
#   })
# }

# # VPC Endpoints
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id             = module.vpc.vpc_id
#   service_name       = "com.amazonaws.${var.region}.ecr.api"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = module.vpc.private_subnets
#   security_group_ids = [aws_security_group.vpc_endpoints.id]
  
#   private_dns_enabled = true

#   tags = merge(var.tags, {
#     Name = "${var.environment}-ecr-api"
#   })
# }

# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id             = module.vpc.vpc_id
#   service_name       = "com.amazonaws.${var.region}.ecr.dkr"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = module.vpc.private_subnets
#   security_group_ids = [aws_security_group.vpc_endpoints.id]
  
#   private_dns_enabled = true

#   tags = merge(var.tags, {
#     Name = "${var.environment}-ecr-dkr"
#   })
# }

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = module.vpc.private_route_table_ids

#   tags = merge(var.tags, {
#     Name = "${var.environment}-s3"
#   })
# }