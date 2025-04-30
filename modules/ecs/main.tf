module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = ">= 5.0.0"

  cluster_name  = "${var.environment}-${var.cluster_name}"
  fargate_capacity_providers = var.fargate_capacity_providers
  tags         = merge(var.tags, { Environment = var.environment, Name = "${var.environment}-${var.cluster_name}" })
}

# IAM role for ECS tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.environment}-ecs-task-execution-role"
  })
}

# Attach the AmazonECSTaskExecutionRolePolicy to the role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.environment}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-ecs-tasks-sg"
  })
}

# Task Definition for the service
resource "aws_ecs_task_definition" "service" {
  family                   = "${var.environment}-${var.service_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = var.cpu
  memory                  = var.memory
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn          = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = "${var.ecr_repository_url}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = concat([
        {
          name  = "DB_HOST"
          value = var.db_endpoint
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_USER"
          value = var.db_username
        },
        {
          name  = "REDIS_HOST"
          value = var.redis_endpoint
        },
        {
          name  = "REDIS_PORT"
          value = "6379"
        }
      ], var.environment_vars)
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_password_arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment}-${var.service_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.service_name}-task"
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "service" {
  name              = "/ecs/${var.environment}-${var.service_name}"
  retention_in_days = 30

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.service_name}-logs"
  })
}
