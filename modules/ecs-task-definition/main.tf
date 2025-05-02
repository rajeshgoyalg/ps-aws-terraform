# Ensure your AWS provider is configured for ap-south-1  
provider "aws" {  
  region = "ap-south-1"  
}  

resource "aws_lb_target_group" "ecs" {
  name        = "nginxdemos-hello-tg"  
  port        = 80  
  protocol    = "HTTP"  
  vpc_id      = var.vpc_id
  target_type = "ip"  # Use "ip" for awsvpc network mode (Fargate)  
    
  health_check {  
    enabled             = true  
    interval            = 30  
    path                = "/"  
    port                = "traffic-port"  
    healthy_threshold   = 3  
    unhealthy_threshold = 3  
    timeout             = 5  
    protocol            = "HTTP"  
    matcher             = "200"  
  }  
}

resource "aws_lb_listener" "http" {  
  load_balancer_arn = var.alb_arn  # ARN of your existing ALB  
  port              = 80  
  protocol          = "HTTP"  
    
  default_action {  
    type             = "forward"  
    target_group_arn = aws_lb_target_group.ecs.arn  
  }  
}
  
module "ecs_service" {  
  source = "terraform-aws-modules/ecs/aws//modules/service"  
  
  name        = "${var.environment}-nginxdemos-hello"  
  cluster_arn = var.cluster_arn
  

  # Load balancer configuration  
  load_balancer = {  
    service = {  
      target_group_arn = aws_lb_target_group.ecs.arn  
      container_name   = "${var.environment}-nginxdemos-hello"  
      container_port   = 80  
    }  
  }
  subnet_ids = var.subnet_ids
  
  # Task definition settings  
  cpu                = 256  
  memory             = 512  
  network_mode       = "awsvpc"  
    
  # Use existing execution role  
  task_exec_iam_role_arn = "arn:aws:iam::180294189279:role/ecsTaskExecutionRole"  
    
  # Fargate compatibility  
  requires_compatibilities = ["FARGATE"]  
  runtime_platform = {  
    operating_system_family = "LINUX"  
    cpu_architecture        = "X86_64"  
  }  
  
  # Container definition  
  container_definitions = {  
    "${var.environment}-nginxdemos-hello" = {  
      name      = "${var.environment}-nginxdemos-hello"  
      image     = "nginxdemos/hello"  
      essential = true  

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false
        
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
    }  
  }  
  
  # If you want to create a service, uncomment and configure these settings  
  # subnet_ids = ["subnet-12345678", "subnet-87654321"]  # Your private subnet IDs  
  security_group_rules = {  
    egress_all = {  
      type        = "egress"  
      from_port   = 0  
      to_port     = 0  
      protocol    = "-1"  
      cidr_blocks = ["0.0.0.0/0"]  
    }  
    ingress_http = {  
      type        = "ingress"  
      from_port   = 80  
      to_port     = 80  
      protocol    = "tcp"  
      source_security_group_id = var.alb_security_group_id
    }  
  }  
}