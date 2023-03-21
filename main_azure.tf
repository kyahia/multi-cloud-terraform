module "vpc_azure" {
  source                = "./modules/vpc/azure"
  azure_subscription_id = var.azure_subscription_id
  azure_resource_group  = var.azure_resource_group
  vpcs = {
    vpc1 = {
      name       = "Vnet"
      location   = "South Central US"
    }
  }
}

module "subnet_azure" {
  source                = "./modules/subnet/azure"
  azure_subscription_id = var.azure_subscription_id
  resource_group_name   = var.azure_resource_group
  location              = "South Central US"
  virtual_network_name  = module.vpc_azure.vpc["vpc1"].name
  subnets = {
    sub1 = {
      name       = "Subnet1"
      type       = "private" # public || private
    },
    sub2 = {
      name       = "Subnet2"
      type       = "public" # public || private
    }
  }
}


module "nat_azure" {
  source                = "./modules/nat/azure"
  azure_subscription_id = var.azure_subscription_id
  resource_group_name   = var.azure_resource_group
  location              = "South Central US"
  name                  = "nat"
  subnets = {
    id1 = module.subnet_azure.subnets["sub1"].id
  }
}

module "vm_azure" {
  source                = "./modules/vm/azure"
  resource_group_name   = var.azure_resource_group
  azure_subscription_id = var.azure_subscription_id
  location              = "South Central US"
  vms = {
    vm1 = {
      name      = "ser1"
      subnet    = module.subnet_azure.subnets["sub1"].id
      pub_ip    = false
      openports = ["80"]
      username  = "admin"
      password  = "Admin.2023"

      configuration = "manual"
      ram           = "8"
      cores         = "2"
      os            = "Ubuntu"
      version       = "18"
      arch          = "X86"
      custom_data   = file("./script.sh")

    },
    vm2 = {
      name      = "ser2"
      subnet    = module.subnet_azure.subnets["sub1"].id
      pub_ip    = false 
      openports = ["80"]
      username  = "admin"
      password  = "Admin.2023"

      configuration = "manual"
      ram     = "8"
      cores   = "2"
      os      = "Ubuntu"
      version = "18"
      arch    = "X86"
      custom_data   = file("./script.sh")
    }
  }
}

module "load_balancer" {
  source                = "./modules/load_balancer/azure"
  resource_group_name   = var.azure_resource_group # required
  virtual_network_id    = module.vpc_azure.vpc["vpc1"].id
  location              = "South Central US"                                                                           # required
  azure_subscription_id = var.azure_subscription_id                                                                    # required
  type                  = "application"                                                                                # not required : network || application
  scheme                = "External"                                                                                   # not required : Internal || External
  subnet                = module.subnet_azure.subnets["sub2"].id                                                #required (empty subnet)c
  name                  = "das-lb"                                                                                        # required
  capacity              = 10                                                                                           # not required
  ports                 = [80]                                                                                         # required
  vms                   = [module.vm_azure.vm["vm1"].private_ip_address, module.vm_azure.vm["vm2"].private_ip_address] #required
}


module "alert" {
  source                = "./modules/alert/azure"                # required
  azure_subscription_id = var.azure_subscription_id              # required
  azure_resource_group  = var.azure_resource_group               # required
  name                  = "das_alert"                             # required
  window_size           = "PT1M"                                 #not required
  threshold             = 10                                     #not required
  load_balancer_id      = module.load_balancer.load_balancer.id
}
