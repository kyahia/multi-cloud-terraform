provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  machines                = jsondecode(file("./modules/vm/aws/machine_types.json"))
  machine_types           = local.machines.machine_types
  image_names             = local.machines.image_names
  x86_instances           = { for machine in local.machine_types : machine.instance_type => "${machine.cpu}_${machine.ram}" if machine.architecture == "x86_64" }
  arm_instances           = { for machine in local.machine_types : machine.instance_type => "${machine.cpu}_${machine.ram}" if machine.architecture == "arm" }
  client_architecture_vms = var.architecture == "x86_64" ? local.x86_instances : local.arm_instances
}

data "aws_ami" "vimages" {
  for_each = var.vms
  most_recent = true
  owners      = ["amazon", "aws-marketplace"]
  filter {
    name   = "name"
    values = [var.configuration == "manual" ? try(local.image_names[each.value.os_name][each.value.os_version]) : "ubuntu*18.04*"]  
  }
  filter {
    name   = "architecture"
    values = [var.architecture]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



resource "aws_instance" "vms" {
  for_each                    = var.vms
  ami                         = data.aws_ami.vimages[each.key].id 
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.sg_aws.id]
  instance_type               = try(each.value.configuration, "auto") == "auto" ? "t2.small" : [for machine_type, cpu_ram in local.client_architecture_vms : machine_type if cpu_ram == "${each.value.cpu_cores}_${each.value.vm_ram}"][0]
  associate_public_ip_address = each.value.public_ip
  user_data                   = try(each.value.user_data, "")
  key_name                    = var.ssh_key != "" ? var.ssh_key : null
  tags = {
    Name = each.value.name
  }
}
