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
  source = "./modules/subnet/aws"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  vpc_id = module.vpc_aws.vpc_id

  subnets = {
    sub1 = {
      type = "public"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name = "subnet-1"
    },
    sub2 = {
      type = "public"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name = "subnet-2"
    },
    sub3 = {
      type = "private"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name = "subnet-3"
    },
    sub4 = {
      type = "private"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
      name = "subnet-4"
    }
  }
  igw_name = "web"
  ngw_name = "web"
}