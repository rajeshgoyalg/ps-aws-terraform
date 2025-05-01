variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}   

variable "subnets" {
  type = list(string)
}

variable "alb_name" {
  type = string
}

variable "tags" {
  type = map(string)
}