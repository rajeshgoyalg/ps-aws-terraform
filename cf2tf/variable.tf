variable ecs_cluster_name {
  type = string
  default = "dev-rg-cluster"
}

variable ecs_service_name {
  type = string
  default = "dev-nginxdemos-hello-service"
}

variable security_group_name {
  type = string
  default = "dev-nginxdemos-hello-service-sg"
}

variable subnet_i_ds {
  type = string
  default = "subnet-02ac79f7e7dafd103,subnet-04892cda6244b897f,subnet-085739ac44ad6f920,subnet-08a4c9ab8385bd335,subnet-0950d55320fa319fa,subnet-070f922ce2399ab66"
}

variable vpc_id {
  type = string
  default = "vpc-0f95d8f2529f0ccb0"
}

variable load_balancer_name {
  type = string
  default = "DemoALBForECS"
}

