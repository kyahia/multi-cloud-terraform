output "vpc_azure" {
  value = module.vpc_azure.vpc
}

output "vm" {
  value = module.vm_azure.vm
  sensitive = true
}
