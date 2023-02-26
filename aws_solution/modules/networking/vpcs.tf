resource "aws_vpc" "web_app_vpc" { # creating a vpc with a cibr_block
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "web-app-vpc"
  }
}
