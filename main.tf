module "vpc_azure" {
  source                = "./modules/vpc/azure"
  azure_subscription_id = var.azure_subscription_id
  vpcs = {
    vpc1 = {
      azure_resource_group = var.azure_resource_group
      name                 = "Vnet-1"
      cidr_block           = "10.0.0.0/16"
      location             = "South Central US"
    },

    vpc2 = {
      azure_resource_group = var.azure_resource_group
      name                 = "Vnet-2"
      cidr_block           = "10.0.0.0/16"
      location             = "South Central US"
    }
  }
}

module "subnet_azure" {
  source                = "./modules/subnet/azure"
  azure_subscription_id = var.azure_subscription_id
  resource_group_name   = var.azure_resource_group
  location              = "South Central US"
  subnets = {
    sub1 = {
      name                 = "Subnet1"
      virtual_network_name = module.vpc_azure.vpc["vpc1"].name
      cidr_block           = "10.0.1.0/24"
      type                 = "public" #public - private with nat
    },
    sub2 = {
      name                 = "Subnet2"
      virtual_network_name = module.vpc_azure.vpc["vpc1"].name
      cidr_block           = "10.0.2.0/24"
      type                 = "private" #public - private with nat
    },
    sub3 = {
      name                 = "Subnet1"
      virtual_network_name = module.vpc_azure.vpc["vpc1"].name
      cidr_block           = "10.0.3.0/24"
      type                 = "public" #public - private with nat
    }
  }
}

# module "vpc_aws" { 
#   source         = "./modules/vpc/aws"
#   aws_access_key = var.aws_access_key
#   aws_secret_key = var.aws_secret_key
#   aws_region     = "us-east-1"
#   vpc = {
#     vpc0 = {
#       cidr_block = "10.0.0.0/16"
#       name       = "web-app-vpc"
#     },
#     vpc1 = {
#       cidr_block = "10.0.0.0/16"
#       name       = "web-app-vpc2"
#     },
#   }
# }


# module "vpc_gcp" {
#   source          = "./modules/vpc/gcp"
#   gcp_credentials = file("./gcp_credentials.json")
#   gcp_project_id  = jsondecode(file("./gcp_credentials.json")).project_id
#   gcp_region      = "us-central1"
#   vpc = {
#     vpc1 = {
#       name                    = "terr-vpc"
#       auto_create_subnetworks = false
#     },
#   }
# }
