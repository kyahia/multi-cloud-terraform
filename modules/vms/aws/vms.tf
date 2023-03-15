provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
locals {
  machines = jsondecode(file("machine_types.json"))
  machine_types = local.machines.machine_types
  image_names               = local.machines.image_names
  x86_instances = {for machine in local.machine_types: machine.instance_type => "${machine.cpu}_${machine.ram}" if machine.architecture == "x86_64"}
  arm_instances = {for machine in local.machine_types: machine.instance_type => "${machine.cpu}_${machine.ram}" if machine.architecture == "arm"}
  client_architecture_vms = var.cpu_architecture == "x86_64"? local.x86_instances: local.arm_instances

}

data "aws_ami" "vimages" {
  most_recent = true
  owners = ["amazon", "aws-marketplace"]
  filter {
    name = "name"
    values = [var.ami_name != "" ? var.ami_name : local.image_names[var.os_name][var.os_version]]
  }
  filter {
    name   = "architecture"
    values = [var.cpu_architecture]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "vms" {
  ami = data.aws_ami.vimages.id
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.sg_aws.id]
  instance_type          = [for machine_type, cpu_ram in local.client_architecture_vms : machine_type if cpu_ram == "${var.cpu_cores}_${var.vm_ram}"][0]
  associate_public_ip_address = false
  user_data                   = file("pr.sh")
  key_name      = aws_key_pair.my_key_pair.key_name
  count                       = var.vm_number
  tags = {
    Name = "vm-${count.index}"
  }
}