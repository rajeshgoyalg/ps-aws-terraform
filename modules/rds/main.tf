data "aws_region" "current" {}

# Create DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = var.db_subnet_group_name
  })
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "${var.environment}-${var.db_name}"

  engine               = "postgres"
  engine_version       = "17.2"
  family               = "postgres17"
  major_engine_version = "17"
  instance_class       = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = var.db_name
  username = var.db_username
  port     = "5432"

  manage_master_user_password = true

  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.db_name}"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.environment}-${var.db_name}-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.db_name}-sg"
  })
} 