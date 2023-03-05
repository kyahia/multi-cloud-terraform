output "gcp_vpc" {
    value = var.enable_gcp ? module.gcp_solution[0].vpc_id : ""
}

output "aws_vpc" {
    value = var.enable_aws ? module.aws_solution[0].vpc_id : ""
}

output "azure_vpc"{
    value = var.enable_azure ? module.azure_solution[0].vpc_id : ""
}
