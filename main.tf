terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
      Owner = "felipe.tomazelli"
    }
  }
}

resource "aws_ecs_cluster" "terraform_lab" {
  name = var.name
}

resource "aws_ecs_task_definition" "nginx" {
  family = var.name
  container_definitions = jsonencode([
    {
      name      = var.name
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
}

data "aws_subnets" "default" {
  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}
data "aws_subnets" "private" {
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

resource "aws_ecs_service" "nginx" {
  name                 = var.name
  cluster              = aws_ecs_cluster.terraform_lab.arn
  task_definition      = aws_ecs_task_definition.nginx.arn
  desired_count        = 1
  force_new_deployment = true
  launch_type          = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_listener.nginx.default_action[0].target_group_arn
    container_name   = var.name
    container_port   = 80
  }
}

resource "aws_lb_target_group" "nginx" {
  name        = var.name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
}

data "aws_vpc" "default" {}

resource "aws_lb" "nginx" {
  name               = var.name
  internal           = false
  subnets            = data.aws_subnets.default.ids
  load_balancer_type = "application"
}

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}