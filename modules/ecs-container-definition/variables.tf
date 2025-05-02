variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}