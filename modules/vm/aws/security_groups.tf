resource "aws_security_group" "sg_aws" {
  vpc_id = var.vpc_id
  name   = "sg"

  dynamic "ingress" {
    for_each = var.open_ports
    content {
      from_port   = ingress.value["port_number"]
      to_port     = ingress.value["port_number"]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    for_each = var.available_ports
    content {
      from_port   = egress.value["port_number"]
      to_port     = egress.value["port_number"]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
