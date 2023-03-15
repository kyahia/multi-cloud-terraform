provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_lb" "net_lb" {
  name               = "net-lb"
  internal           = false
  load_balancer_type = "network"
  #security_groups    = [aws_security_group.allow_http.id]
  subnets            = var.subnets
  enable_cross_zone_load_balancing = true

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "net_lb_target_group" {
  #name_prefix       = "my_target_group"
  port              = 80
  protocol          = "TCP"
  vpc_id            = var.vpc_id
  target_type       = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 15
    interval            = 30
    path                = "/"
  }

  tags = {
    Name = "My Target Group"
  }
}

resource "aws_lb_target_group_attachment" "net_lb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.net_lb_target_group.arn
  for_each = var.vm_ids
  target_id        = each.value
  port             = 80
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.net_lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.net_lb_target_group.arn
    type             = "forward"
  }
}