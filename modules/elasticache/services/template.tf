module "SERVICE_NAME_cache" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "~> 1.6.0"

  # Cache Configuration
  cluster_id           = "${var.environment}-SERVICE_NAME"
  engine              = "redis"
  engine_version      = "6.2"
  node_type           = "cache.t3.micro"
  num_cache_nodes     = 1
  port                = 6379

  # Network Configuration
  subnet_group_name   = var.subnet_group_name
  security_group_ids  = [aws_security_group.SERVICE_NAME_cache.id]

  # Maintenance Configuration
  maintenance_window = "mon:03:00-mon:04:00"
  snapshot_window    = "04:00-05:00"

  # Tags
  tags = merge(var.tags, {
    Service     = "SERVICE_NAME"
    Environment = var.environment
  })
}

# Security Group for SERVICE_NAME Cache
resource "aws_security_group" "SERVICE_NAME_cache" {
  name        = "${var.environment}-SERVICE_NAME-cache-sg"
  description = "Security group for SERVICE_NAME cache"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-SERVICE_NAME-cache-sg"
  })
} 