# Configure ALB listener and target group  
module "alb" {  
  source = "terraform-aws-modules/alb/aws"  
  
  # Use existing ALB - only create listeners and target groups  
  create = true  
  name   = var.alb_name  # Name of your existing ALB  
  
  # These values should match your existing ALB configuration  
  vpc_id  = var.vpc_id  
  subnets = var.subnets  
  
  # Create a target group for the ECS service  
  target_groups = {  
    flask-app = {  
      name_prefix      = "flask-"  
      backend_protocol = "HTTP"  
      backend_port     = 3000  
      target_type      = "ip"  # Use IP as target type for Fargate  
      health_check = {  
        enabled             = true  
        interval            = 30  
        path                = "/"  
        port                = "traffic-port"  
        healthy_threshold   = 3  
        unhealthy_threshold = 3  
        timeout             = 6  
        protocol            = "HTTP"  
        matcher             = "200-399"  
      }  
    }  
  }  
  
  # Create a listener for the ALB  
  listeners = {  
    http = {  
      port     = 80  
      protocol = "HTTP"  
        
      # Forward traffic to the target group  
      forward = {  
        target_group_key = "flask-app"  
      }  
    }  
  }  

  tags = merge(var.tags, {
    Name = "${var.environment}-alb-listener-tg"
  })
}