module "vpc_gcp" {
  source          = "./modules/vpc/gcp"
  gcp_credentials = file("./gcp_credentials.json")
  gcp_project_id  = jsondecode(file("./gcp_credentials.json")).project_id
  gcp_region      = "us-central1"
  vpc = {
    vpc1 = {
      name = "vpc"
    },
  }
}

module "subnet_gcp" {
  source          = "./modules/subnet/gcp"
  gcp_credentials = file("./gcp_credentials.json")
  gcp_project_id  = jsondecode(file("./gcp_credentials.json")).project_id
  gcp_region      = "us-central1"
  cidr_mode       = "auto"
  vpc_name        = module.vpc_gcp.vpc["vpc1"].name

  subnets = {
    first = {
      name = "subnet1"
      type = "public"
    },
    sec = {
      name = "subnet2"
      type = "private"
    }
  }
}

module "subnet_gcp3" {
  source           = "./modules/subnet/gcp"
  gcp_credentials  = file("./gcp_credentials.json")
  gcp_project_id   = jsondecode(file("./gcp_credentials.json")).project_id
  gcp_region       = "us-central1"
  cidr_mode        = "auto"
  previous_subnets = flatten([module.subnet_gcp.private_subnets, module.subnet_gcp.public_subnets])
  vpc_name         = module.vpc_gcp.vpc["vpc1"].name

  subnets = {
    third = {
      name = "subnet1"
      type = "public"
    },
    fourth = {
      name = "subnet2"
      type = "private"
    }
  }
}

module "subnet_gcp2" {
  source          = "./modules/subnet/gcp"
  gcp_credentials = file("./gcp_credentials.json")
  gcp_project_id  = jsondecode(file("./gcp_credentials.json")).project_id
  gcp_region      = "us-central1"
  vpc_name        = module.vpc_gcp.vpc["vpc1"].name

  subnets = {
    ahmed = {
      name       = "subnet3"
      cidr_block = "10.0.55.0/24"
      type       = "public"
    },
    djcher = {
      name       = "subnet4"
      cidr_block = "10.0.66.0/24"
      type       = "private"
    }
  }
}

# module "vpc_azure" {
#   source                = "./modules/vpc/azure"
#   azure_subscription_id = var.azure_subscription_id
#   vpcs = {
#     vpc1 = {
#       azure_resource_group = var.azure_resource_group
#       name                 = "Vnet-1"
#       cidr_block           = "10.0.0.0/16"
#       location             = "South Central US"
#     },

#     vpc2 = {
#       azure_resource_group = var.azure_resource_group
#       name                 = "Vnet-2"
#       cidr_block           = "10.0.0.0/16"
#       location             = "South Central US"
#     }
#   }
# }

# module "subnet_azure" {
#   source                = "./modules/subnet/azure"
#   azure_subscription_id = var.azure_subscription_id
#   resource_group_name   = var.azure_resource_group
#   location              = "South Central US"
#   subnets = {
#     sub1 = {
#       name                 = "Subnet1"
#       vpc = module.vpc_azure.vpc["vpc1"].name
#       cidr_block           = "10.0.1.0/24"
#       type                 = "public"
#     },
#     sub2 = {
#       name                 = "Subnet2"
#       vpc = module.vpc_azure.vpc["vpc1"].name
#       cidr_block           = "10.0.2.0/24"
#       type                 = "private"
#     },
#     sub3 = {
#       name                 = "Subnet1"
#       vpc = module.vpc_azure.vpc["vpc1"].name
#       cidr_block           = "10.0.3.0/24"
#       type                 = "public"
#     }
#   }
# }

# # module "vpc_aws" { 
# #   source         = "./modules/vpc/aws"
# #   aws_access_key = var.aws_access_key
# #   aws_secret_key = var.aws_secret_key
# #   aws_region     = "us-east-1"
# #   vpc = {
# #     vpc0 = {
# #       cidr_block = "10.0.0.0/16"
# #       name       = "web-app-vpc"
# #     },
# #     vpc1 = {
# #       cidr_block = "10.0.0.0/16"
# #       name       = "web-app-vpc2"
# #     },
# #   }
# # }
