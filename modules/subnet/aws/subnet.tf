resource "aws_subnet" "public_subnet" {
  for_each = var.subnet
  vpc_id = each.value.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags = {
    name = each.value.subnet_name
  }
}