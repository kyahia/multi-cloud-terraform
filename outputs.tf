output "azure_dns"{
    value = module.azure_solution.dns_ip
}

output "gcp_dns" {
    value = module.gcp_solution.http_lb_ip
}

output "aws_dns" {
    value = module.aws_solution.web_app_elb_dns_name
}