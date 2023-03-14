terraform {
  required_providers {
    aws = {
      source  = "Hashicorp/aws"
      version = "4.0"
    }
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}

data "aws_ami" "vm_images" {
  most_recent = true
  owners      = ["amazon", "137112412989"] # owner id for fedora images
  filter {
    name   = "name"
    values = ["ubuntu*18.04*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

output "ami_image_id" {
    value = data.aws_ami.vm_images.image_id
}

output "ami_id" {
    value = data.aws_ami.vm_images.id
}


resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "ami_test_vm" {
  depends_on = [
    aws_route_table.private_routing
  ]
  ami = data.aws_ami.vm_images.id
  #ami = "ami-0883f2d26628ad0cf"
  subnet_id = aws_subnet.ami_test_subnet2.id
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
  instance_type = "t2.micro"
  associate_public_ip_address = false
  user_data = file("pr.sh")
  key_name      = aws_key_pair.my_key_pair.key_name
  count=2
  tags = {
      Name = "ami-test-vm${count.index}"
  }
}

resource "aws_instance" "bastion" {
  depends_on = [
    aws_route_table.private_routing
  ]
  ami = data.aws_ami.vm_images.id
  subnet_id = aws_subnet.ami_test_subnet1.id
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
  instance_type = "t2.micro"
  associate_public_ip_address = true
  user_data = file("pr.sh")
  key_name      = aws_key_pair.my_key_pair.key_name
  tags = {
      Name = "bastion"
  }
}

resource "aws_instance" "target_vm" {
  depends_on = [
    aws_route_table.private_routing
  ]
  ami = data.aws_ami.vm_images.id
  subnet_id = aws_subnet.ami_test_subnet2.id
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
  instance_type = "t2.micro"
  associate_public_ip_address = false
  user_data = file("pr.sh")
  key_name      = aws_key_pair.my_key_pair.key_name
  tags = {
      Name = "target-vm"
  }
}

#resource "aws_launch_configuration" "my-launch-config" {
#  count = 3
#  image_id = data.aws_ami.vm_images.id
#  instance_type = "t2.micro"
#  security_groups = [aws_security_group.my-security-group.id]
#  user_data = <<EOF
#              #!/bin/bash
#              echo "Hello World" > /var/www/html/index.html
#              EOF
#  lifecycle {
#    create_before_destroy = true
#  }
#}
#

locals {
  vm_ids = {for vm in aws_instance.ami_test_vm: vm.tags.Name => vm.id}
}
output "vm_ids" {
  value = local.vm_ids
}