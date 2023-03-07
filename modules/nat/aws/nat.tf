provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region
}

resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = "elastic-nat-gateway-ip-adress"
  }
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = var.public_subnet_id
  tags = {
    Name = var.nat_name == null ? "nat-gateway" : var.nat_name
  }
}
