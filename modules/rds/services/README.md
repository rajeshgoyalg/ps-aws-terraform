# RDS Service Modules

This directory contains service-specific RDS instance configurations. Each service has its own configuration file that inherits from the template.

## Directory Structure

```
services/
├── template.tf      # Template for new RDS services
├── variables.tf     # Common variables
└── user-service.tf  # Example service configuration
```

## Adding a New Service

1. Copy the template:
```bash
cp template.tf new-service.tf
```

2. Update the configuration in `new-service.tf`:
```hcl
module "new_service_db" {
  source = "./template"

  # Service Configuration
  environment = var.environment
  service_name = "new-service"

  # Database Configuration
  engine         = "postgres"
  engine_version = "14.7"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  db_name       = "new_service"
  db_username   = "new_service_admin"
  db_password_arn = "arn:aws:secretsmanager:region:account:secret:new-service-db-password"

  # Network Configuration
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  security_group_ids = [aws_security_group.new_service_db.id]

  # Tags
  tags = var.tags
}
```

3. Add security group if needed:
```hcl
resource "aws_security_group" "new_service_db" {
  name        = "${var.environment}-new-service-db-sg"
  description = "Security group for New Service database"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-new-service-db-sg"
  })
}
```

## Required Variables

- `environment`: Environment name (dev/prod)
- `service_name`: Name of the service
- `vpc_id`: VPC ID
- `private_subnet_ids`: List of private subnet IDs
- `allowed_security_groups`: List of security group IDs allowed to access the database
- `monitoring_role_arn`: ARN of the IAM role for enhanced monitoring

## Optional Variables

- `engine`: Database engine (default: postgres)
- `engine_version`: Engine version (default: 14.7)
- `instance_class`: Instance type (default: db.t3.micro)
- `allocated_storage`: Storage in GB (default: 20)
- `backup_retention_period`: Days to retain backups (default: 7)
- `backup_window`: Backup window (default: "03:00-04:00")
- `maintenance_window`: Maintenance window (default: "mon:04:00-mon:05:00")
- `monitoring_interval`: Enhanced monitoring interval in seconds (default: 60)

## Best Practices

1. Always use unique identifiers for each service
2. Follow naming conventions: `${environment}-${service_name}`
3. Use appropriate instance types based on workload
4. Configure appropriate security groups
5. Enable monitoring and backups
6. Use parameter groups for custom configurations
7. Tag resources consistently 