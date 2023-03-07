
resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = "elastic-nat-gateway-ip-adress"
  }
}

resource "aws_nat_gateway" "nat" {
  
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = var.subnet.public_subnet_id
  tags = {
    Name = "${var.nat_name}nat-gateway"
  }
}