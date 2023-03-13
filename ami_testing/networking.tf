
resource "aws_vpc" "ami_test_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ami-test-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.ami_test_vpc.id
    tags = {
        Name = "ami-igw"
    }
}

resource "aws_subnet" "ami_test_subnet" {
  vpc_id            = aws_vpc.ami_test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ami-test-subnet"
  }
}

resource "aws_route_table" "public_routing" {
    vpc_id = aws_vpc.ami_test_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "ami-public-routing"
    }
}

resource "aws_route_table_association" "ami-association" {
    subnet_id = aws_subnet.ami_test_subnet.id
    route_table_id = aws_route_table.public_routing.id
}
