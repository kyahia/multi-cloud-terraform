provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_subnet" "subnets" {
  vpc_id = var.vpc_id
  for_each = var.subnets
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = each.value.name
  }
}

locals {
  public_subnets = {for key, value in var.subnets: key=>key if value.type == "public"}
  private_subnets = {for key, value in var.subnets: key=>key if value.type == "private"}
  public_subnet_names = [for key, value in local.public_subnets: value]
  private_subnet_ids = {for key, value in local.private_subnets: key => aws_subnet.subnets[key].id}
}
