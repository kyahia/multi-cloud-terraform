# Configure the AWS Provider
locals {
  vpc_keys = [for key, value in var.vpcs: key]
}
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "vpc" {
  for_each   = var.vpcs
  cidr_block = try(each.value.cidr_block, "10.0.0.0/16")

  tags = {
    Name = each.value.name
  }
}
