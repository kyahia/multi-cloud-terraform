module "vpc_aws" {
  source         = "./modules/vpc/aws"
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


module "subnet_aws" {
  source = "./modules/subnet/aws"
  aws_region     = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  subnets = {
    sub1 = {
      vpc_id = module.vpc_aws.vpc_id
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      tags = {
        Name = "subnet-1"
      }
    }
    sub2 = {
      vpc_id = module.vpc_aws.vpc_id
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
      tags = {
        Name = "subnet-2"
      }
    }
  }
}