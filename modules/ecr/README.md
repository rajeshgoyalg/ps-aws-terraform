# ECR Module

This module creates an Elastic Container Registry repository with lifecycle policies and security settings.

## Features

- ECR repository
- Lifecycle policies
- Image scanning
- Encryption
- Tag mutability settings

## Usage

```hcl
module "ecr" {
  source              = "./modules/ecr"
  environment         = var.environment
  repository_name     = var.repository_name
  image_tag_mutability = "MUTABLE"
  scan_on_push        = true
  encryption_type     = "AES256"
  tags                = var.tags
  create_lifecycle_policy = var.create_lifecycle_policy
}
```

## Outputs

- `repository_url`: The URL of the repository
- `repository_arn`: The ARN of the repository
- `repository_name`: The name of the repository 