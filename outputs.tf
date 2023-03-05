
output "gcp_dns" {
  value = var.enable_gcp ? module.gcp_solution[0].http_lb_ip : ""
}

output "aws_dns" {
  value = var.enable_aws ? module.aws_solution[0].web_app_elb_dns_name : ""
}

output "azure_dns" {
  value = var.enable_azure ? module.azure_solution[0].dns_ip : ""
}
