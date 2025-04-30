module "demoapp1_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  # Database Configuration
  identifier = "${var.environment}-demoapp1"
  engine     = "postgres"
  engine_version = "14.7"
  family     = "postgres14"
  major_engine_version = "14"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  max_allocated_storage = 100

  db_name  = "demoapp1"
  username = "demoapp1_admin"
  port     = "5432"

  # Network Configuration
  multi_az               = true
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.demoapp1_db.id]

  # Backup Configuration
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  # Tags
  tags = merge(var.tags, {
    Service     = "demoapp1"
    Environment = var.environment
  })
}

# Security Group for demoapp1 Database
resource "aws_security_group" "demoapp1_db" {
  name        = "${var.environment}-demoapp1-db-sg"
  description = "Security group for demoapp1 database"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-demoapp1-db-sg"
  })
} 