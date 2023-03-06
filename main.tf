module "vpc_azure" {
  source                = "./modules/vpc/azure"
  azure_subscription_id = var.azure_subscription_id
  type = "private"
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
  source         = "./modules/vpc/aws"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = "us-east-1"
  vpc = {
    vpc0 = {
      cidr_block = "10.0.0.0/16"
      name       = "web-app-vpc"
    },
    vpc1 = {
      cidr_block = "10.0.0.0/16"
      name       = "web-app-vpc2"
    },
  }
}


module "vpc_gcp" {
  source          = "./modules/vpc/gcp"
  gcp_credentials = file("./gcp_credentials.json")
  gcp_project_id  = jsondecode(file("./gcp_credentials.json")).project_id
  gcp_region      = "us-central1"
  vpc = {
    vpc1 = {
      name                    = "terr-vpc"
      auto_create_subnetworks = false
    },
  }
}
