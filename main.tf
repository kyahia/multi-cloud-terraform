module "vpc_azure" {
  source                = "./modules/vpc/azure"
  azure_subscription_id = var.azure_subscription_id
  azure_resource_group  = var.azure_resource_group
  cidr_mode             = "auto" # auto || "manual"
  vpcs = {
    vpc1 = {
      name       = "Vnet-1"  
      cidr_block = "20.0.0.0/16"
      location   = "South Central US"
    } #,

    # vpc2 = {
    #   name       = "Vnet-2"
    #   cidr_block = "20.0.0.0/16"
    #   location   = "South Central US"
    # }
  }
}

module "subnet_azure" {
  source                = "./modules/subnet/azure"
  azure_subscription_id = var.azure_subscription_id
  resource_group_name   = var.azure_resource_group
  location              = "South Central US"
  virtual_network_name  = module.vpc_azure.vpc["vpc1"].name
  cidr_mode             = "auto" # auto || "manual"
  subnets = {
    sub1 = {
      name       = "Subnet1"
      cidr_block = "10.0.5.0/24"
      type       = "private" # public || private
    },
    sub2 = {
      name       = "Subnet2"
      cidr_block = "10.0.10.0/24"
      type       = "public" # public || private
    },
    sub3 = {
      name       = "Subnet3"
      cidr_block = "10.0.10.0/24"
      type       = "public" # public || private
    },
  }
}


module "nat_azure" {
  source                = "./modules/nat/azure"
  azure_subscription_id = var.azure_subscription_id
  resource_group_name   = var.azure_resource_group
  location              = "South Central US"
  name                  = "auto-nat"
  subnets = {
    id1 = module.subnet_azure.public_subnets["sub2"].id #,
    # id2 = module.subnet_azure.public_subnets["sub3"].id
  }
}


#To modify nat assos it should be created before and give its id as parameter
# module "nat_azure1" {
#   source                = "./modules/nat/azure"
#   azure_subscription_id = var.azure_subscription_id
#   resource_group_name   = var.azure_resource_group
#   location              = "South Central US"
#   name                  = "auto-nat"
#   nat_id = module.nat_azure.nat_id
#   subnets = {
#     sub1 = module.subnet_azure.private_subnets["sub2"].id
#   }
# }

module "vm_azure" {
  source                = "./modules/vm/azure"
  resource_group_name   = var.azure_resource_group
  azure_subscription_id = var.azure_subscription_id
  location              = "South Central US"
  vms = {
    vm1 = {
      name      = "Vm1"
      subnet    = module.subnet_azure.public_subnets["sub2"].id
      pub_ip    = true #enable | disable
      openports = ["80", "22", "443"]
      username  = "djalil"
      password  = "Abdeldjalil.1999"
      # ssh_key   = file("./id_rsa.pub") #not required

      configuration = "auto" # "auto" || "manual"
      ram         = "8"
      cores       = "2"
      os          = "Ubuntu"
      version     = "18"
      arch        = "X86"
      custom_data = filebase64("./script.sh")

    },
    vm2 = {
      name      = "Vm2"
      subnet    = module.subnet_azure.public_subnets["sub2"].id
      pub_ip    = true #enable | disable
      openports = ["80", "22"]
      username  = "djalil"
      password  = "Abdeldjalil.1999"
      # ssh_key   = file("./id_rsa.pub") #not required

      configuration = "manual" # "auto" || "manual"

      ram     = "8"
      cores   = "2"
      os      = "Windows"
      version = "2016"
      arch    = "X86"
      # custom_data = filebase64("./script.sh")
    },
    vm3 = {
      name      = "Vm3"
      subnet    = module.subnet_azure.public_subnets["sub2"].id
      pub_ip    = false #enable | disable
      openports = ["80"]
      username  = "djalil"
      password  = "Abdeldjalil.1999"
      # ssh_key   = file("./id_rsa.pub") #not required

      configuration = "auto" # "auto" || "manual"

      ram         = "8"
      cores       = "2"
      os          = "Ubuntu"
      version     = "18"
      arch        = "X86"
      custom_data = filebase64("./script.sh")

    }

  }

}

# module "load_balancer" {
#   source                = "./modules/load_balancer/azure"
#   resource_group_name   = var.azure_resource_group                      # required
#   azure_subscription_id = var.azure_subscription_id                     #required
#   type                  = "application"                                 # not required : network || application
#   scheme                = "Internal"                                    # not required : internal || external
#   location              = "South Central US"                            #required
#   subnet                = module.subnet_azure.public_subnets["sub3"].id #required (empty subnet)
#   name                  = "lb1" #required
#   capacity              = 10   #not required
#   ports                 = [80] #required
#   vms                   = [module.vm_azure.vm["vm1"].private_ip_address, module.vm_azure.vm["vm3"].private_ip_address]
# }

module "load_balancer2" {
  source                = "./modules/load_balancer/azure"
  resource_group_name   = var.azure_resource_group # required
  virtual_network_id    = module.vpc_azure.vpc["vpc1"].id
  location              = "South Central US"                                                                           # required
  azure_subscription_id = var.azure_subscription_id                                                                    # required
  type                  = "application"                                                                                # not required : network || application
  scheme                = "External"                                                                                   # not required : Internal || External
  subnet                = module.subnet_azure.public_subnets["sub3"].id                                                #required (empty subnet)c
  name                  = "lb2"                                                                                        # required
  capacity              = 10                                                                                           # not required
  ports                 = [80]                                                                                         # required
  vms                   = [module.vm_azure.vm["vm1"].private_ip_address, module.vm_azure.vm["vm3"].private_ip_address] #required
}


module "alert" {
  source                = "./modules/alert/azure"                # required
  azure_subscription_id = var.azure_subscription_id              # required
  azure_resource_group  = var.azure_resource_group               # required
  name                  = "my_alert"                             # required
  window_size           = "PT1M"                                 #not required
  threshold             = 10                                     #not required
  load_balancer_id      = module.load_balancer2.load_balancer.id #required
}



