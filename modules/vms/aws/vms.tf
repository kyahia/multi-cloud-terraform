locals ={
  ec2_instances = jsondecode(file("ec2_instances.json"))
  ami_names = local.ec2_instances.ami_names
  x86_instances = {for machine in local.ec2_instances.vm_types: "vm_types" => machine if machine.architecture =="x86"}
  arm_instances = {for machine in local.ec2_instances.vm_types: "vm_types" => machine if machine.architecture =="arm"}
  client_architecture_vms = var.architecture == "x86" ? local.x86_intances : local.arm_instances
}
data "aws_ami" "vimages" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = [var.vm_ami.ami_name != "" ? vm_ami.ami_name : local.ami_names[var.vm_ami.os_name][var.vm_ami.os_version]]
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
resource "aws_instance" "vms" {
  ami             = data.aws_ami.vimages.id
  subnet_id       = var.private_subnet_id
  vpc_security_group_ids = [var.sg_id]
  instance_type   = [for machine in local.client_architecture_vms: machine.machine_type if machine.cpu_ram=="${var.cpu_cores}_${var.ram}"][0]
  user_data       = file("pr.sh")
  count        = var.number_vms
  tags = {
    Name = "vm-${count.index}"
  }
}
