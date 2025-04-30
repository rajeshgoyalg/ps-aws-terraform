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
      port                = "traffic-port"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      timeout             = 5
      protocol            = "HTTP"
      matcher             = "200"
    }
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name               = "${var.environment}-${var.alb_name}"
  vpc_id             = var.vpc_id
  subnets            = var.private_subnet_ids
  internal           = false

  security_groups = [aws_security_group.alb.id]

  # HTTP Listener
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  # HTTPS Listener
  https_listeners = var.certificate_arn != "" ? [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.certificate_arn
      target_group_index = 0
    }
  ] : []

  # Target Groups
  target_groups = concat(
    [local.default_target_group],
    var.target_groups
  )

  tags = merge(var.tags, {
    Environment = var.environment
    Name        = "${var.environment}-${var.alb_name}"
  })
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-alb-sg"
    }
  )
}
