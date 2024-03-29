resource "aws_route_table" "public_routing" {
  # count  = length(local.public_subnets) > 0 && var.internet_gateway_id == "" ? 1 : 0
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id != "" ? var.internet_gateway_id : try(aws_internet_gateway.igw[0].id, "")
  }
  tags = {
    Name = "routing-for-public-subnet"
  }
}
