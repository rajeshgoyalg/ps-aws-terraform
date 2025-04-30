locals {
  service_name = var.service_name
  environment  = var.environment
}

# RDS Instance
module "rds" {
  source = "../rds"

  environment = local.environment
  db_name     = local.service_name
  db_username = var.db_username
  instance_class = var.config.db_instance_class
  db_subnet_group_name = var.db_subnet_group_name
  vpc_id = var.vpc_id
  allowed_security_groups = [var.ecs_tasks_sg_id]
  tags = merge(var.tags, {
    Service = local.service_name
  })
}

# ElastiCache Cluster
# module "elasticache" {
#   source = "../elasticache"

#   environment = local.environment
#   cache_name = local.service_name
#   node_type = var.config.cache_node_type
#   subnet_group_name = var.elasticache_subnet_group_name
#   vpc_id = var.vpc_id
#   allowed_security_groups = [var.ecs_tasks_sg_id]
#   tags = merge(var.tags, {
#     Service = local.service_name
#   })
# }

# ECS Task Definition
resource "aws_ecs_task_definition" "service" {
  family                   = "${local.environment}-${local.service_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = var.config.cpu
  memory                  = var.config.memory
  execution_role_arn      = var.ecs_task_execution_role_arn
  task_role_arn          = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = local.service_name
      image     = "${var.ecr_repository_url}${var.config.image_tag != "" ? ":" + var.config.image_tag : ":latest"}"
      essential = true
      portMappings = [
        {
          containerPort = var.config.container_port
          hostPort      = var.config.host_port
          protocol      = "tcp"
        }
      ]
      environment = concat(
        [
          {
            name  = "DB_HOST"
            value = module.rds.db_instance_endpoint
          },
          {
            name  = "DB_PORT"
            value = "5432"
          },
          {
            name  = "DB_NAME"
            value = module.rds.db_instance_name
          },
          {
            name  = "DB_USER"
            value = module.rds.db_instance_username
          },
          {
            name  = "REDIS_HOST"
            value = module.elasticache.cache_cluster_endpoint
          },
          {
            name  = "REDIS_PORT"
            value = "6379"
          }
        ],
        var.config.environment_vars
      )
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = module.rds.db_instance_password_arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${local.environment}-${local.service_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name = "${local.environment}-${local.service_name}-task"
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "service" {
  name              = "/ecs/${local.environment}-${local.service_name}"
  retention_in_days = 30

  tags = merge(var.tags, {
    Name = "${local.environment}-${local.service_name}-logs"
  })
}

# Service Discovery
resource "aws_service_discovery_service" "service" {
  name = local.service_name
  dns_config {
    namespace_id = var.service_discovery_namespace_id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}

# Auto Scaling
resource "aws_appautoscaling_target" "service" {
  max_capacity       = var.config.max_capacity
  min_capacity       = var.config.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "service" {
  name               = "${local.service_name}-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service.resource_id
  scalable_dimension = aws_appautoscaling_target.service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 75.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

# ECS Service
resource "aws_ecs_service" "service" {
  name            = local.service_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.config.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_tasks_sg_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.service.arn
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service.arn
    container_name   = local.service_name
    container_port   = var.config.container_port
  }

  depends_on = [aws_lb_target_group.service]
}

# ALB Target Group
resource "aws_lb_target_group" "service" {
  name        = "${local.environment}-${local.service_name}-tg"
  port        = var.config.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.config.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = merge(var.tags, {
    Name = "${local.environment}-${local.service_name}-tg"
  })
} 