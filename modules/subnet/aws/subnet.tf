locals {
  public_subnets = {for key, value in var.subnets: key=>key if value.type == "public"}
  private_subnets = {for key, value in var.subnets: key=>key if value.type == "private"}
  private_subnets_with_nat = {for key, value in var.subnets: key=>key if value.type == "private_with_nat"}
  public_subnet_names = [for key, value in local.public_subnets: value]
}

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