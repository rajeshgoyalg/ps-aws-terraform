variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository (without environment prefix)"
  type        = string
}

variable "create_lifecycle_policy" {
  description = "Indicates whether a lifecycle policy should be created for the repository."
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type for the repository."
  type        = string
  default     = "AES256"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
