provider "aws" {  
  region = "ap-south-1"  
}

module "container_definition" {  
  source = "terraform-aws-modules/ecs/aws//modules/container-definition"  
  
  name      = "${var.environment}-nginxdemos-hello"  
  image     = "nginxdemos/hello"  
  essential = true  
    
  port_mappings = [  
    {  
      name          = "${var.environment}-nginxdemos-hello-80-tcp"  
      containerPort = 80  
      hostPort      = 80  
      protocol      = "tcp"  
      appProtocol   = "http"  
    }  
  ]  
    
  # log_configuration = {  
  #   logDriver = "awslogs"  
  #   options = {  
  #     "awslogs-group"         = "/ecs/${var.environment}-nginxdemos-hello"  
  #     "mode"                  = "non-blocking"  
  #     "awslogs-create-group"  = "true"  
  #     "max-buffer-size"       = "25m"  
  #     "awslogs-region"        = "ap-south-1"  
  #     "awslogs-stream-prefix" = "ecs"  
  #   }  
  # }  
    
  # Optional: If you want the module to create the CloudWatch log group  
  # create_cloudwatch_log_group            = true  
  # cloudwatch_log_group_name              = "/ecs/${var.environment}-nginxdemos-hello"  
  # cloudwatch_log_group_retention_in_days = 30  

  tags = merge(var.tags, {
    Name = "${var.environment}-nginxdemos-hello"
  })
}