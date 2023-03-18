# output "image_ids" {
#   value = data.aws_ami.vimage
# }

output "vms" {
  value = aws_instance.vms
}

output "sg_id" {
  value = aws_security_group.sg_aws.id
}
