
output "image_id" {
  value = data.aws_ami.vimages.id
}

output "vm_ids" {
    value = {for vm in aws_instance.vms: vm.tags.Name => vm.id}
}

output "sg_id" {
    value = aws_security_group.sg_aws.id
}