data "aws_ami" "vimages" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = [var.vm_type]
  }
  filter {
    name   = "architecture"
    values = [var.vm_type]
  }
  filter {
    name   = "virtualization-type"
    values = [var.vm_type]
  }
}
resource "aws_instance" "vms" {
  ami             = data.aws_ami.vimages.id
  subnet_id       = var.private_subnet_id
  vpc_security_group_ids = [var.sg_id]
  instance_type   = "t2.micro"
  user_data       = file("pr.sh")
  count        = var.number_vms
  tags = {
    Name = "vm-${count.index}"
  }
}
