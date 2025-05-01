locals {
  default_target_group = {
    name             = "${var.environment}-default-tg"
    backend_protocol = "HTTP"
    backend_port     = 80
    target_type      = "ip"
    health_check = {
      enabled             = true
      interval            = 30
      path                = "/"
      # port                = "traffic-port"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      timeout             = 5
      protocol            = "HTTP"
      matcher             = "200"
    }
  }
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "${var.environment}-ps-alb-sg"
  description = "${var.environment} - Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # HTTPS listener - not needed for Internal Load Balancer
  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
      Name = "${var.environment}-ps-alb-sg"
    }
  )
}

# ALB Module
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name     = "${var.environment}-${var.alb_name}"
  vpc_id   = var.vpc_id
  subnets  = var.private_subnet_ids
  internal = true

  # Security Group
  security_groups = [aws_security_group.alb.id]

  # Target Groups
  target_groups = concat(
    [local.default_target_group],
    var.target_groups
  )

  # HTTP Listener
  listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0 # Reference the first target group
    }
  ]

  # HTTPS Listener
  # https_listeners = var.certificate_arn != "" ? [
  #   {
  #     port               = 443
  #     protocol           = "HTTPS"
  #     certificate_arn    = var.certificate_arn
  #     target_group_index = 0
  #   }
  # ] : []

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.alb_name}"
  })
}
