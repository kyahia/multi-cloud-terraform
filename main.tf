module "vpc_azure" {
  source = "./modules/vpc/azure"
  azure_subscription_id = var.azure_subscription_id
  vpc = {
    vpc1 = {
      azure_resource_group = var.azure_resource_group
      vnet_name            = "Vnet-1"
      azure-cidr_vnet      = "10.0.0.0/16"
      location             = "South Central US"
    },

    vpc2 = {
      azure_resource_group = var.azure_resource_group
      vnet_name            = "Vnet-2"
      azure-cidr_vnet      = "10.0.0.0/16"
      location             = "South Central US"
    }
  }
}

module "vpc_aws" {
  source = "./modules/vpc/aws"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  vpc = {
      vpc1 = {
        cidr_block = "10.0.0.0/16"
        name       = "web-app-vpc"
      },
  }
}








# module "gcp_solution" {
#   source        = "./gcp_solution"
#   project_id    = local.gcp_project_id
#   count         = var.enable_gcp ? 1 : 0
#   servers_count = var.servers_count
# }

# module "aws_solution" {
#   source        = "./aws_solution"
#   count         = var.enable_aws ? 1 : 0
#   servers_count = var.servers_count
# }

# module "azure_solution" {
#   source              = "./azure_solution"
#   location            = var.enable_azure ? var.azure_location : ""
#   resource_group_name = var.enable_azure ? var.azure_resource_group : ""
#   count               = var.enable_azure ? 1 : 0
#   servers_count       = var.servers_count
# }
