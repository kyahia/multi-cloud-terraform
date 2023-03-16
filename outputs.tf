output "vpc_gcp" {
  value = module.vpc_gcp.vpc
}

/* output "os" {
  value = module.vm.os_name
} */

# output "vpc_azure" {
#   value = module.vpc_azure.vpc
# }

# output "vpc_gcp" {
#   value = module.vpc_gcp.vpc["vpc1"].id
#   }



# output "gcp_dns" {
#   value = var.enable_gcp ? module.gcp_solution[0].http_lb_ip : ""
# }

# output "aws_dns" {
#   value = var.enable_aws ? module.aws_solution[0].web_app_elb_dns_name : ""
# }

# output "azure_dns" {
#   value = var.enable_azure ? module.azure_solution[0].dns_ip : ""
# }

output "filtred_machines" {
  value = module.vm.machine_filter
}

output "islem" {
  value = module.load_balancer.vm
  sensitive = true
}
