# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.environment}-ecs-task-execution-role"
  })
}

# IAM Policy for ECS Task Execution Role
resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = "${var.environment}-ecs-task-execution-policy"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR Permissions
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage"
        ]
        Resource = module.ecr.repository_arn
      },
      # CloudWatch Logs Permissions (for FireLens and ECS logging)
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      # Optional: Secrets Manager and SSM Parameter Store (if your tasks use secrets)
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "ssm:GetParameters"
        ]
        Resource = [
          "arn:aws:secretsmanager:ap-south-1:123456789012:secret:ecs/*", # Adjust to your secret ARNs
          "arn:aws:ssm:ap-south-1:123456789012:parameter/ecs/*"          # Adjust to your parameter ARNs
        ]
      }
    ]
  })
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.0"

  repository_name                 = "${var.environment}-${var.repository_name}"
  repository_image_tag_mutability = var.image_tag_mutability
  repository_image_scan_on_push   = var.repository_image_scan_on_push
  repository_encryption_type      = var.repository_encryption_type
  create_lifecycle_policy         = var.create_lifecycle_policy

  # Lifecycle policy to manage image retention
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.image_retention_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.image_retention_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.repository_name}" 
  })
}
