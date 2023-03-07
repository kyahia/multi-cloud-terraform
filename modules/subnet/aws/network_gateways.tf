locals {
  public_subnets = {for key, value in var.subnets: key=>key if value.type == "public"}
  private_subnets = {for key, value in var.subnets: key=>key if value.type == "private"}
  public_subnet_names = [for key, value in local.public_subnets: value]
}
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.igw_name}internet-gateway"
  }
}

resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = "elastic-nat-gateway-ip-adress"
  }
}

resource "aws_nat_gateway" "nat" {
  
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.subnets[local.public_subnet_names[0]].id
  tags = {
    Name = "${var.ngw_name}nat-gateway"
  }
}