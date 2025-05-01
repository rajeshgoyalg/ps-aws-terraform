module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "~> 5.0"

  name               = "${var.environment}-${var.service_name}"
  cluster_arn        = module.ecs_cluster.cluster_arn

  cpu                = var.cpu
  memory             = var.memory

  launch_type        = var.launch_type

  # container Definition
  container_definitions = {
    "${var.service_name}-container" = {
      cpu          = var.cpu
      memory       = var.memory
      essential    = true
      image        = var.container_image
      portMappings = [
        { 
          name          = "${var.service_name}-container"
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  }

  service_connect_configuration = {
    namespace = var.service_name
     "${var.service_name}" = {
      client_alias = {
        port     = 80
        dns_name = var.service_name
      }
      port_name      = var.service_name
      discovery_name = var.service_name
    }
  }

  load_balancer = {
    service = {
      target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:1234567890:targetgroup/bluegreentarget1/209a844cd01825a4"
      container_name   = var.service_name
      container_port   = 80
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    "alb_ingress_${var.container_port}" = {
      type                     = "ingress"
      from_port                = var.container_port
      to_port                  = var.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = "sg-12345678"
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Tags
  tags = var.tags
}

# Security Group for ECS Service
resource "aws_security_group" "ecs_service" {
  name_prefix = "${var.environment}-${var.service_name}-ecs-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Allow ALB to ECS service"
  }

  # Allow inter-service communication
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = var.service_security_groups
    description     = "Allow communication between services"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.service_name}-ecs-sg"
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${var.environment}-${var.service_name}"
  retention_in_days = 7
  tags              = var.tags
}

# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.environment}-${var.service_name}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.private_subnets

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.service_name}-alb"
  })
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.environment}-${var.service_name}-alb-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_block
    description = "Allow VPC traffic to ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.service_name}-alb-sg"
  })
}

resource "aws_lb_target_group" "this" {
  name_prefix = "${substr(var.service_name, 0, 6)}-"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = var.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.container_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = var.tags
}

# Auto Scaling
resource "aws_appautoscaling_target" "this" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.cluster_id}/${var.environment}-${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "${var.environment}-${var.service_name}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70
  }
}