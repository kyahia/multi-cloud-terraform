provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
locals {
  ec2_instances           = jsondecode(file("ec2_instances.json"))
  ami_names               = local.ec2_instances.ami_names
  x86_instances           = { for machine in local.ec2_instances.vm_types : machine.machine_type => machine.cpu_ram if machine.architecture == "x86" }
  arm_instances           = { for machine in local.ec2_instances.vm_types : machine.machine_type => machine.cpu_ram if machine.architecture == "arm" }
  client_architecture_vms = var.cpu_architecture == "x86_64" ? local.x86_instances : local.arm_instances
}

data "aws_ami" "vimages" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    #values = [var.ami_name != "" ? var.ami_name : local.ami_names[var.os_name][var.os_version]]
    values = ["CentOS*"]
  }
  filter {
    name   = "architecture"
    values = [var.cpu_architecture]
    #values = ["x86_64"]
  }
  #filter {
  #  name   = "virtualization-type"
  #  values = ["hvm"]
  #}
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "vms" {
  ami = data.aws_ami.vimages.id
  #ami             = "ami-00874d747dde814fa"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.sg_aws.id]
  instance_type          = [for machine_type, cpu_ram in local.client_architecture_vms : machine_type if cpu_ram == "${var.cpu_cores}_${var.vm_ram}"][0]
  #instance_type   = "t2.micro"
  associate_public_ip_address = true
  user_data                   = file("pr.sh")
  key_name      = aws_key_pair.my_key_pair.key_name
  count                       = var.vm_number
  tags = {
    Name = "vm-${count.index}"
  }
}