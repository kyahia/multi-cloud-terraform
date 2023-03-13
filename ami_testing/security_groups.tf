resource "aws_security_group" "allow_http" {
  vpc_id = aws_vpc.ami_test_vpc.id
  name   = "allow-http"
  ingress {
      from_port   = 80 
      to_port     = 80 
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-http"
  }
}
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.ami_test_vpc.id
  name   = "allow-ssh"
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-ssh"
  }
}
