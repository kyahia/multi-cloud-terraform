module "vpc_aws" {
  source         = "./modules/vpc/aws"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  vpcs = {
    vpc1 = {
      cidr_block = "10.0.0.0/16"
      name       = "web-app-vpc"
    },
  }
}

module "subnet_aws" {
  source              = "./modules/subnet/aws"
  aws_region          = var.aws_region
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  vpc_id              = module.vpc_aws.vpc_id
  internet_gateway_id = ""
  subnets = {
    sub1 = {
      type              = "public"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name              = "subnet-1"
    },
    sub2 = {
      type              = "public"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
      name              = "subnet-2"
    },
    sub3 = {
      type              = "private"
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1b"
      name              = "subnet-3"
    }
    sub4 = {
      type              = "private"
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"
      name              = "subnet-4"
    }
  }
}

module "nat_aws" {
  source             = "./modules/nat/aws/"
  aws_region         = var.aws_region
  aws_access_key     = var.aws_access_key
  aws_secret_key     = var.aws_secret_key
  vpc_id             = module.vpc_aws.vpc_id
  private_subnet_ids =  module.subnet_aws.private_subnet_ids
  public_subnet_id   = module.subnet_aws.public_subnet_id
}


module "compute_vms" {
  source            = "./modules/vms/aws"
  aws_region        = var.aws_region
  aws_access_key    = var.aws_access_key
  aws_secret_key    = var.aws_secret_key
  vpc_id            = module.vpc_aws.vpc_id
  subnet_id = module.subnet_aws.private_subnet_id
  available_ports    = { allow_http = { port_number = 80 }, allow_ssh = { port_number = 22 } }
  os_name          = "ubuntu"
  os_version       = "18.04"
  cpu_architecture = "x86_64"
  cpu_cores        = 1
  vm_ram           = 2
  vm_number        = 2
}

module "load_balancer" {
  source            = "./modules/load_balancers/aws"
  aws_region        = var.aws_region
  aws_access_key    = var.aws_access_key
  aws_secret_key    = var.aws_secret_key
  vpc_id            = module.vpc_aws.vpc_id
  subnets = [module.subnet_aws.private_subnet_id, module.subnet_aws.public_subnet_id]
  internal = false
  load_balancer_type = "application"
  vm_ids = module.compute_vms.vm_ids
}

module "alert" {
  source = "./modules/alert/aws"
  aws_region        = var.aws_region
  aws_access_key    = var.aws_access_key
  aws_secret_key    = var.aws_secret_key
  lb_name = module.load_balancer.lb.name
}