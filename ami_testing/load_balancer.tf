resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  #security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.ami_test_subnet1.id, aws_subnet.ami_test_subnet2.id]
  enable_cross_zone_load_balancing = true

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "my_target_group" {
  #name_prefix       = "my_target_group"
  port              = 80
  protocol          = "TCP"
  vpc_id            = aws_vpc.ami_test_vpc.id
  target_type       = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
  }

  tags = {
    Name = "My Target Group"
  }
}

resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  for_each = local.vm_ids
  target_id        = each.value
  port             = 80
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "forward"
  }
}