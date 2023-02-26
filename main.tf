module "gcp_solution" {
  source = "./gcp_solution"
  project_id = local.gcp_project_id
}

module "aws_solution" {
  source = "./aws_solution"
}

module "azure_solution" {
  source = "./azure_solution"
  location = var.azure_location
  resource_group_name = var.azure_resource_group
}
