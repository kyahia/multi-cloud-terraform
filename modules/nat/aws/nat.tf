provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_eip" "elastic_ip" {
  count = var.nat_id == "" ? 1 : 0
  vpc   = true
  tags = {
    Name = "elastic-nat-gateway-ip-adress"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.nat_id == "" ? 1 : 0
  allocation_id = aws_eip.elastic_ip[0].id
  subnet_id     = var.public_subnet_id
  tags = {
    Name = var.nat_name
  }
}

resource "aws_route_table" "private_routing" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_id == "" ? aws_nat_gateway.nat[0].id : var.nat_id
  }
  tags = {
    Name = "routing-private-subnet"
  }
}

resource "aws_route_table_association" "route_to_nat" {
  for_each       = var.private_subnet_ids # this will loop throught the keys (name) of each private subnet
  subnet_id      = each.value
  route_table_id = aws_route_table.private_routing.id
}
