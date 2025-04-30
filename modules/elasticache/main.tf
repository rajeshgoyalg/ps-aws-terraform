module "cache" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "~> 1.6.0"

  cluster_id           = "${var.environment}-${var.cache_name}-cache"
  replication_group_id = "${var.environment}-${var.cache_name}-cache"
  engine              = "redis"
  engine_version      = "6.2"
  node_type           = var.cache_node_type
  num_cache_nodes     = 1
  port                = 6379

  subnet_group_name   = var.subnet_group_name
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.cache.id]

  maintenance_window = "mon:03:00-mon:04:00"
  snapshot_window    = "04:00-05:00"

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.cache_name}"
  })
}

# Security Group for Redis
resource "aws_security_group" "cache" {
  name        = "${var.environment}-${var.cache_name}-sg"
  description = "Security group for Redis instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.cache_name}-sg"
  })
} 