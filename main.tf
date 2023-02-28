module "gcp_solution" {
  source = "./gcp_solution"
  project_id = local.gcp_project_id
  count = var.enable_gcp ? 1 : 0
}

module "aws_solution" {
  source = "./aws_solution"
  count = var.enable_aws ? 1 : 0
}

module "azure_solution" {
  source = "./azure_solution"
  location = var.enable_azure ? var.azure_location : ""
  resource_group_name = var.enable_azure ? var.azure_resource_group : ""
  count = var.enable_azure ? 1 : 0
}
