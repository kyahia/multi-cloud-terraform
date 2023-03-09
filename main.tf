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

/* module "subnet_gcp" {
  source                  = "./modules/subnet/gcp"
  gcp_credentials         = file("./gcp_credentials.json")
  gcp_project_id          = jsondecode(file("./gcp_credentials.json")).project_id
  gcp_region              = "us-central1"
  cidr_mode               = "auto"
  vpc_name                = module.vpc_gcp.vpc["vpc1"].name

  subnets = {
    first = {
      name = "subnet1"
      type = "public"
    },
    scd = {
      name = "subnet2"
      type = "private"
    },
    thd = {
      name = "subnet3"
      type = "private"
    },
  }
} */

module "nat_association" {
  source  = "./modules/nat/gcp"
  gcp_credentials         = file("./gcp_credentials.json")
  gcp_project_id          = jsondecode(file("./gcp_credentials.json")).project_id
  gcp_region              = "us-central1"
  subnets = module.subnet_gcp2.private_subnets
  vpc_name = module.vpc_gcp.vpc["vpc1"].name
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
    },
    djcher2 = {
      name       = "subnet4"
      cidr_block = "10.0.4.0/24"
      type       = "private"
    }
  }
}