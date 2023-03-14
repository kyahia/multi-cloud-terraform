
output "image_id" {
  value = data.aws_ami.vimages.id
}

output "vm_id" {
    value = {for vm in aws_instance.vms: vm.tags.Name => vm.id}
}