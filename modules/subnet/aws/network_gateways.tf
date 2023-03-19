resource "aws_internet_gateway" "igw" {
  count  = length(local.public_subnets) != 0 && var.internet_gateway_id == "" ? 1 : 0
  vpc_id = var.vpc_id
}
