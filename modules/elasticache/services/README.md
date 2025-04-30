# ElastiCache Service Modules

This directory contains service-specific ElastiCache cluster configurations. Each service has its own configuration file that inherits from the template.

## Directory Structure

```
services/
├── template.tf      # Template for new cache services
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
module "new_service_cache" {
  source = "./template"

  # Service Configuration
  environment = var.environment
  service_name = "new-service"

  # Cache Configuration
  engine         = "redis"
  engine_version = "6.2"
  node_type      = "cache.t3.micro"
  num_cache_nodes = 1
  port           = 6379

  # Network Configuration
  subnet_group_name  = var.subnet_group_name
  security_group_ids = [aws_security_group.new_service_cache.id]

  # Maintenance Configuration
  maintenance_window = "mon:03:00-mon:04:00"
  snapshot_window    = "04:00-05:00"
  snapshot_retention_limit = 7

  # Tags
  tags = var.tags
}
```

3. Add security group if needed:
```hcl
resource "aws_security_group" "new_service_cache" {
  name        = "${var.environment}-new-service-cache-sg"
  description = "Security group for New Service cache"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-new-service-cache-sg"
  })
}
```

## Required Variables

- `environment`: Environment name (dev/prod)
- `service_name`: Name of the service
- `vpc_id`: VPC ID
- `subnet_group_name`: Name of the subnet group
- `allowed_security_groups`: List of security group IDs allowed to access the cache

## Optional Variables

- `engine`: Cache engine (default: redis)
- `engine_version`: Engine version (default: 6.2)
- `node_type`: Cache node type (default: cache.t3.micro)
- `num_cache_nodes`: Number of cache nodes (default: 1)
- `port`: Cache port (default: 6379)
- `maintenance_window`: Maintenance window (default: "mon:03:00-mon:04:00")
- `snapshot_window`: Snapshot window (default: "04:00-05:00")
- `snapshot_retention_limit`: Days to retain snapshots (default: 7)
- `parameter_group_name`: Parameter group name (default: "default.redis6.x")

## Best Practices

1. Always use unique identifiers for each service
2. Follow naming conventions: `${environment}-${service_name}`
3. Use appropriate node types based on workload
4. Configure appropriate security groups
5. Enable snapshots for data persistence
6. Use parameter groups for custom configurations
7. Tag resources consistently
8. Consider using Redis Cluster mode for high availability
9. Monitor cache metrics and adjust capacity as needed 