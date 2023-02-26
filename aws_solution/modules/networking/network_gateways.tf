resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_app_vpc.id

  tags = {
    Name = "web-app-internet-gateway"
  }
}


resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = "elastic-nat-gateway-ip-adress"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "web-app-nat-gateway"
  }
}

