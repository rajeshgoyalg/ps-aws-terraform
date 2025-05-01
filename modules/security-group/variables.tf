variable "environment" {
  description = "Environment name for the security group"
  type        = string
  default     = "Development"
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group for resources in the VPC"
}

# variable "ingress_rules" {
#   description = "List of ingress rules for the security group"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#     description = string
#   }))
#   default = []
# }

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type        = list(string)
}

variable "ingress_cidr_blocks" {
  description = "List of ingress CIDR blocks for the security group"
  type        = list(string)
}

# variable "ingress_with_cidr_blocks" {
#   description = "List of ingress rules with CIDR blocks for the security group"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = string
#     description = string
#   }))
#   default = []
# }

# variable "egress_rules" {
#   description = "List of egress rules for the security group"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#     description = string
#   }))
#   default = []
# }

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type        = list(string)
}

variable "egress_cidr_blocks" {
  description = "List of egress CIDR blocks for the security group"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}