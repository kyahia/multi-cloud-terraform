resource "aws_route_table" "public_routing" {
  vpc_id = aws_vpc.web_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "routing-for-public-subnet"
  }
}

resource "aws_route_table" "private_routing" {
  vpc_id = aws_vpc.web_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "routing-for-private-subnet"
  }
}
