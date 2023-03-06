# Configure the AWS Provider
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "vpc" {
  for_each   = var.vpc
  cidr_block = each.value.cidr_block

  tags = {
    Name = each.value.name
  }
}
