module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.0"

  repository_name                 = "${var.environment}-${var.repository_name}"
  repository_image_tag_mutability = var.image_tag_mutability
  repository_image_scan_on_push   = var.scan_on_push
  repository_encryption_type      = var.encryption_type
  create_lifecycle_policy         = var.create_lifecycle_policy
  tags                            = merge(var.tags, { Environment = var.environment, Name = "${var.environment}-${var.repository_name}" })
}
