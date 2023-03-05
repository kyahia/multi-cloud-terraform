output "vm_ids" {
  value = aws_instance.web_app_vms.*.id
}

