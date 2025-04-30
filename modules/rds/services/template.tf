module "SERVICE_NAME_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  # Database Configuration
  identifier = "${var.environment}-SERVICE_NAME"
  engine     = "postgres"
  engine_version = "17.2"
  family     = "postgres17"
  major_engine_version = "17"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  max_allocated_storage = 100

  db_name  = "SERVICE_NAME"
  username = "SERVICE_NAME_admin"
  port     = "5432"

  # Network Configuration
  multi_az               = false
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.SERVICE_NAME_db.id]

  # Backup Configuration
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  # Tags
  tags = merge(var.tags, {
    Service     = "SERVICE_NAME"
    Environment = var.environment
  })
}

# Security Group for SERVICE_NAME Database
resource "aws_security_group" "SERVICE_NAME_db" {
  name        = "${var.environment}-SERVICE_NAME-db-sg"
  description = "Security group for SERVICE_NAME database"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-SERVICE_NAME-db-sg"
  })
} 