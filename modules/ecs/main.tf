# ECS Cluster - Using the cluster created by ecs_cluster module
data "aws_ecs_cluster" "main" {
  cluster_name = var.cluster_name
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

  tags = var.tags
}

# Attach the AmazonECSTaskExecutionRolePolicy to the role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  count = var.create_security_group ? 1 : 0

  name        = "${var.environment}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Task Definition for the service
resource "aws_ecs_task_definition" "service" {
  family                   = "${var.environment}-service"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = var.cpu
  memory                  = var.memory
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn           = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "service"
      image     = var.ecr_repository_url
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DB_ENDPOINT"
          value = var.db_endpoint
        },
        # {
        #   name  = "REDIS_ENDPOINT"
        #   value = var.redis_endpoint
        # }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment}-service"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = var.tags
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "service" {
  name              = "/ecs/${var.environment}-${var.service_name}"
  retention_in_days = 30

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.service_name}-logs"
  })
}

resource "aws_ecs_service" "service" {
  name            = "${var.environment}-service"
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.create_security_group ? aws_security_group.ecs_tasks[0].id : var.ecs_tasks_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "service"
    container_port   = var.container_port
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]

  tags = var.tags
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-task-role"

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

  tags = var.tags
}

data "aws_region" "current" {}
