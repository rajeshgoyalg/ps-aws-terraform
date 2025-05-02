resource "aws_ecs_service" "ecs_service" {
  cluster = "dev-rg-cluster"
  task_definition = "arn:aws:ecs:us-east-1:180294189279:task-definition/dev-nginxdemos-hello:1"
  launch_type = "FARGATE"
  name = "dev-nginxdemos-hello-service"
  scheduling_strategy = "REPLICA"
  desired_count = 1
  availability_zone_rebalancing = "ENABLED"
  load_balancer = [
    {
      container_name = "nginxdemos-hello"
      container_port = 80
      load_balancer = null
      target_group_arn = aws_elasticache_parameter_group.target_group.id
    }
  ]
  network_configuration {
    // CF Property(AwsvpcConfiguration) = {
    //   AssignPublicIp = "ENABLED"
    //   SecurityGroups = [
    //     aws_security_group.security_group.arn
    //   ]
    //   Subnets = var.subnet_i_ds
    // }
  }
  platform_version = "LATEST"
  // CF Property(DeploymentConfiguration) = {
  //   DeploymentCircuitBreaker = {
  //     Enable = true
  //     Rollback = true
  //   }
  //   MaximumPercent = 200
  //   MinimumHealthyPercent = 100
  // }
  deployment_controller {
    type = "ECS"
  }
  service_connect_configuration {
    enabled = false
  }
  enable_ecs_managed_tags = true
}

resource "aws_security_group" "security_group" {
  description = "dev-nginxdemos-hello-service SG"
  name = "dev-nginxdemos-hello-service-sg"
  vpc_id = "vpc-0f95d8f2529f0ccb0"
  ingress = [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      ipv6_cidr_blocks = "::/0"
    }
  ]
}

resource "aws_elasticsearch_domain_policy" "load_balancer" {
  // CF Property(Type) = "application"
  domain_name = "DemoALBForECS"
  // CF Property(SecurityGroups) = [
  //   aws_security_group.security_group.arn
  // ]
  // CF Property(Subnets) = var.subnet_i_ds
}

resource "aws_elasticache_parameter_group" "target_group" {
  // CF Property(HealthCheckPath) = "/"
  name = "tg-dev-nginxdemos-hello-service"
  // CF Property(Port) = 80
  // CF Property(Protocol) = "HTTP"
  // CF Property(TargetType) = "ip"
  // CF Property(HealthCheckProtocol) = "HTTP"
  // CF Property(VpcId) = var.vpc_id
  // CF Property(TargetGroupAttributes) = [
  //   {
  //     Key = "deregistration_delay.timeout_seconds"
  //     Value = "300"
  //   }
  // ]
}

resource "aws_load_balancer_listener_policy" "listener" {
  // CF Property(DefaultActions) = [
  //   {
  //     Type = "forward"
  //     TargetGroupArn = aws_elasticache_parameter_group.target_group.id
  //   }
  // ]
  load_balancer_name = aws_elasticsearch_domain_policy.load_balancer.domain_name
  load_balancer_port = 80
  // CF Property(Protocol) = "HTTP"
}

