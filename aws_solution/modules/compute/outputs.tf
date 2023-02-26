output "vm1_id" {
  value = aws_instance.web_app_vms["vm1"].id
}

output "vm2_id" {
  value = aws_instance.web_app_vms["vm2"].id
}
