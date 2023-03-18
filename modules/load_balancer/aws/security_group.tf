resource "aws_security_group" "app_lb_sg" {
  count = var.sg_id != "" ? 1 : 0
  vpc_id = var.vpc_id
  name   = "app-lb-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "app-lb-sg"
  }
  
}