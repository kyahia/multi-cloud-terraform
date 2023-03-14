module "vpc_gcp" {
  source          = "./modules/vpc/gcp"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
  gcp_region      = "us-central1"
  vpc = {
    vpc1 = {
      name = "vpc"
    },
  }
}

module "subnet_gcp" {
  source                  = "./modules/subnet/gcp"
  gcp_credentials         = file("./creds.json")
  gcp_project_id          = jsondecode(file("./creds.json")).project_id
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
}

module "nat_association" {
  source  = "./modules/nat/gcp"
  gcp_credentials         = file("./creds.json")
  gcp_project_id          = jsondecode(file("./creds.json")).project_id
  gcp_region              = "us-central1"
  subnetworks = module.subnet_gcp.private_subnets
  vpc_name = module.vpc_gcp.vpc["vpc1"].name
}

module "vm" {
  source = "./modules/vm/gcp"
  gcp_credentials         = file("./creds.json")
  gcp_project_id          = jsondecode(file("./creds.json")).project_id
  gcp_region              = "us-central1"
  vpc_name                = module.vpc_gcp.vpc["vpc1"].name
  vms = {
    vm1 = {
      name            = "vm-private-1" # vm name
      subnet          = module.subnet_gcp.private_subnets["scd"] # subnet where the vm should be 
      public_ip       = false
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80"] # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "arm"
      os_version      = "18" # operating system version
      machine_type    = "f1-micro" # machine type
      script          = file("./script.sh") # script to provision the machine
    },
    vm2 = {
      name            = "vm-private-2" # vm name
      subnet          = module.subnet_gcp.private_subnets["scd"] # subnet where the vm should be 
      public_ip       = false
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80"] # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      ram             = 16 # amount of random access memory
      cores           = 4 # cores of cpu
      arch            = "x86"
      os_version      = "18" # operating system version
      machine_type    = "f1-micro" # machine type
      script          = file("./script.sh") # script to provision the machine
    },
  }
}


/* module "subnet_gcp2" {
  source          = "./modules/subnet/gcp"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
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
} */