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
      availability_zone = "us-east-1a"
      name              = "subnet-3"
    }
    sub4 = {
      type              = "private"
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1a"
      name              = "subnet-4"
    }
  }
}

#module "nat_aws_" {
#  source             = "./modules/nat/aws/"
#  aws_region         = var.aws_region
#  aws_access_key     = var.aws_access_key
#  aws_secret_key     = var.aws_secret_key
#  private_subnet_ids = {id1 = "subnet-0fdd3a92381bdfe2f"}
#  #private_subnet_ids = module.subnet_aws.private_subnet_ids
#  public_subnet_id   = "subnet-040f21ff455fae9e9"
#  #public_subnet_id   =  module.subnet_aws.public_subnet_id
#  vpc_id             = "vpc-05a0f290a5fbc5438"
#  #vpc_id             = module.vpc_aws.vpc_id
#}


#module "nat_aws" {
#  source             = "./modules/nat/aws/"
#  aws_region         = var.aws_region
#  aws_access_key     = var.aws_access_key
#  aws_secret_key     = var.aws_secret_key
#  #private_subnet_ids = {id1 = "subnet-0fdd3a92381bdfe2f"}
#  private_subnet_ids = module.subnet_aws.private_subnet_ids
#  #public_subnet_id   = "subnet-040f21ff455fae9e9"
#  public_subnet_id   =  module.subnet_aws.public_subnet_id
#  #vpc_id             = "vpc-05a0f290a5fbc5438"
#  vpc_id             = module.vpc_aws.vpc_id
#}


#module "nat_aws1" {
#  source             = "./modules/nat/aws/"
#  aws_region         = var.aws_region
#  aws_access_key     = var.aws_access_key
#  aws_secret_key     = var.aws_secret_key
#  private_subnet_ids = {id1 = "subnet-01ed3f0a51b32eeb1", id2 ="subnet-03b79e553572c65a0"}
#  private_subnet_ids = module.subnet_aws.private_subnet_ids
#  public_subnet_id   = "subnet-040f21ff455fae9e9"
#  vpc_id             = "vpc-05a0f290a5fbc5438"
#  #vpc_id             = module.vpc_aws.vpc_id
#  nat_id = "nat-009645508bd61a4e0"
#}

module "compute_vms" {
  source            = "./modules/vms/aws"
  aws_region        = var.aws_region
  aws_access_key    = var.aws_access_key
  aws_secret_key    = var.aws_secret_key
  vpc_id            = module.vpc_aws.vpc_id
  private_subnet_id = module.subnet_aws.public_subnet_id
  available_ports    = { allow_http = { port_number = 80 }, allow_ssh = { port_number = 22 } }
  #ami_name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  #ami_name = "Fedora-32-*x86_64-hvm-*-"
  os_name          = "centos"
  os_version       = "7"
  cpu_architecture = "x86_64"
  cpu_cores        = 1
  vm_ram           = 2
  vm_number        = 2
}