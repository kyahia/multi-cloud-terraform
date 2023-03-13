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
    values = ["amzn*"]
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
    ami = data.aws_ami.vm_images.id
    #ami = "ami-0883f2d26628ad0cf"
    subnet_id = aws_subnet.ami_test_subnet.id
    vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
    instance_type = "t2.micro"
    associate_public_ip_address = true
    user_data = file("pr.sh")
    key_name      = aws_key_pair.my_key_pair.key_name
    tags = {
        Name = "ami-test-vm"
    }
}
