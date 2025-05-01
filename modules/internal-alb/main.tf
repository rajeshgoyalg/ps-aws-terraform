module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name               = "${var.environment}-${var.alb_name}"
  load_balancer_type = "application"
  internal           = true

  vpc_id  = var.vpc_id
  subnets = var.private_subnet_ids

  security_groups = var.security_groups

    # HTTP Listener
  listeners = {
    http = {
      port               = 80
      protocol           = "HTTP"
      forward = {
        target_groups = [
          {
            target_group_key = "http_tg"
            port = 80
          }
        ]
      }
    }
  }

  target_groups = {
    ex-instance = {
      name_prefix                       = "h1"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_anomaly_mitigation = "on"
      load_balancing_cross_zone_enabled = false

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
      target_id        = var.target_id
      port             = 80
      tags = {
        InstanceTargetGroupTag = "baz"
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.alb_name}"
  })
}

# module "alb_sg" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 5.0"

#   name        = "${var.environment}-alb-sg"
#   description = "Security group for internal ALB"
#   vpc_id      = var.vpc_id

#   ingress_cidr_blocks = [var.vpc_cidr]
#   ingress_rules       = ["http-80-tcp"]

#   egress_cidr_blocks = [var.vpc_cidr]
#   egress_rules       = ["http-80-tcp"]

#   tags = merge(var.tags, {
#     Name = "${var.environment}-${var.alb_name}-sg"
#   })
# }