locals {
  vm_names = {
    vm1 = { name = "ubuntu-vm1" },
    vm2 = { name = "ubuntu-vm2" }
  }
}
data "aws_ami" "vimages" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "web_app_vms" {
  ami             = data.aws_ami.vimages.id
  subnet_id       = var.private_subnet_id
  vpc_security_group_ids = [var.allow_http_sg_id]
  instance_type   = "t2.micro"
  user_data       = file("pr.sh")
  for_each        = local.vm_names
  tags = {
    Name = each.value.name
  }
}
