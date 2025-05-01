module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.0"

  cluster_name = "${var.environment}-${var.cluster_name}"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/${var.environment}-${var.cluster_name}"
      }
    }
  }

  # Enable Container Insights
  cluster_settings = [
    {
      "name": "containerInsights",
      "value": "enabled"
    }
  ]

  # Capacity Providers
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = var.capacity_provider_weights.fargate
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = var.capacity_provider_weights.fargate_spot
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.cluster_name}"
  })
}