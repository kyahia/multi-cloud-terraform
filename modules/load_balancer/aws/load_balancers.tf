provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_lb" "lb" {
  name                             = "lb"
  internal                         = var.scheme == "internal" ? true : false
  load_balancer_type               = var.type
  security_groups                  = var.type == "network" ? null : var.sg_id != "" ? [var.sg_id] : [try(aws_security_group.app_lb_sg[0].id, "")]
  subnets                          = var.subnets
  enable_cross_zone_load_balancing = true

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  port        = 80
  protocol    = var.type == "network" ? "TCP" : "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 15
    interval            = 30
    path                = "/"
  }

  tags = {
    Name = "target-group"
  }
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
  for_each         = var.vm_ids
  target_group_arn = aws_lb_target_group.lb_target_group.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = var.type == "network" ? "TCP" : "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    type             = "forward"
  }
}
