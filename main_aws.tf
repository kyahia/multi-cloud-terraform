
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
  vpc_id              = module.vpc_aws.vpcs["vpc1"].id
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
      availability_zone = "us-east-1b"
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
      availability_zone = "us-east-1b"
      name              = "subnet-4"
    }
  }
}

module "nat_aws" {
  source         = "./modules/nat/aws/"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  vpc_id         = module.vpc_aws.vpcs["vpc1"].id
  private_subnet_ids = {
    sub1 = module.subnet_aws.subnets["sub3"].id,
    sub2 = module.subnet_aws.subnets["sub4"].id
  }
  public_subnet_id = module.subnet_aws.subnets["sub2"].id
}


module "compute_vms" {
  source         = "./modules/vm/aws"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  vpc_id         = module.vpc_aws.vpcs["vpc1"].id
  subnet_id      = module.subnet_aws.subnets["sub3"].id
  open_ports       = [80]
  vms = {
    vm1 = {
      name             = "ser1"
      os_name          = "ubuntu"
      os_version       = "22.04"
      cpu_architecture = "x86_64"
      cpu_cores        = 1
      vm_ram           = 2
      public_ip        = false
      user_data        = file("./script.sh")
    },
    vm2 = {
      name             = "ser2"
      os_name          = "ubuntu"
      os_version       = "20.04"
      cpu_architecture = "x86_64"
      cpu_cores        = 1
      vm_ram           = 2
      public_ip        = false
      user_data        = file("./script.sh")
    }
  }
}

module "load_balancer" {
  source         = "./modules/load_balancer/aws"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  vpc_id         = module.vpc_aws.vpcs["vpc1"].id
  subnets        = [module.subnet_aws.subnets["sub3"].id, module.subnet_aws.subnets["sub4"].id]
  scheme         = "external"
  type           = "application"
  vm_ids = {
    vm1 = module.compute_vms.vms["vm1"].id,
    vm2 = module.compute_vms.vms["vm2"].id
  }
}

module "alert" {
  source         = "./modules/alert/aws"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  lb_name        = module.load_balancer.lb.name
}

