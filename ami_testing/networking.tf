
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

resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = "elastic-nat-gateway-ip-adress"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.ami_test_subnet1.id
  tags = {
    Name = "nat gateway"
  }
}

resource "aws_subnet" "ami_test_subnet1" {
  vpc_id            = aws_vpc.ami_test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ami-test-subnet"
  }
}

resource "aws_subnet" "ami_test_subnet2" {
  vpc_id            = aws_vpc.ami_test_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
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

resource "aws_route_table" "private_routing" {
    vpc_id = aws_vpc.ami_test_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
        Name = "ami-private-routing"
    }
}

resource "aws_route_table_association" "public_route_association" {
    subnet_id = aws_subnet.ami_test_subnet1.id
    route_table_id = aws_route_table.public_routing.id
}

resource "aws_route_table_association" "private_routing_association" {
    subnet_id = aws_subnet.ami_test_subnet2.id
    route_table_id = aws_route_table.private_routing.id
}