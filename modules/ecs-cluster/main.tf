resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
    }
  )
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = keys(var.fargate_capacity_providers)

  dynamic "default_capacity_provider_strategy" {
    for_each = var.fargate_capacity_providers
    content {
      capacity_provider = default_capacity_provider_strategy.key
      weight            = default_capacity_provider_strategy.value.default_capacity_provider_strategy.weight
    }
  }
}

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

  tags = merge(var.tags, { Name = "${var.environment}-ecs-tasks-sg" })
}

resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name        = "${var.environment}.local"
  description = "Service discovery namespace for ${var.environment}"
  vpc         = var.vpc_id

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = 30

  tags = var.tags
} 