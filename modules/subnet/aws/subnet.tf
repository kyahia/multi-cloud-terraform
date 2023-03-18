provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


locals {
  subnet_keys    = [for k, v in var.subnets : k]
  starting_index = length(flatten(var.previous_subnets))
}


resource "aws_subnet" "subnets" {
  vpc_id            = var.vpc_id
  for_each          = var.subnets
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, index(local.subnet_keys, each.key) + local.starting_index)
  availability_zone = each.value.availability_zone
  tags = {
    Name = each.value.name
  }
}

locals {
  public_subnets  = { for key, value in var.subnets : key => aws_subnet.subnets[key] if value.type == "public" }
  private_subnets = { for key, value in var.subnets : key => aws_subnet.subnets[key] if value.type == "private" }
}
