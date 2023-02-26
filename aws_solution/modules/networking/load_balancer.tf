resource "aws_elb" "web_app_lb" {
  name     = "web-app-load-balancer"
  internal = false
  subnets  = [aws_subnet.public_subnet.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  security_groups = [aws_security_group.allow_http.id]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 15
    target              = "HTTP:80/"
  }

  instances = [
    var.vm1_id,
    var.vm2_id
  ]

  tags = {
    Name = "web-app-load-balancers"
  }

}
