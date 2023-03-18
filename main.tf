module "vpc_gcp" {
  source          = "./modules/vpc/gcp"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
  gcp_region      = "us-central1"
  vpc = {
    vpc1 = {
      name = "vpc"
    }
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
  subnets = module.subnet_gcp.private_subnets
  vpc_name = module.vpc_gcp.vpc["vpc1"].name
}

module "vm" {
  source = "./modules/vm/gcp"
  gcp_credentials         = file("./creds.json")
  gcp_project_id          = jsondecode(file("./creds.json")).project_id
  gcp_region              = "us-central1"
  zone                    = "us-central1-a"
  vpc_name                = module.vpc_gcp.vpc["vpc1"].name
  vms = {
    vm1 = {
      name            = "vm-private-1" # vm name must include private or public , TODO: we need to prevent this
      subnet          = module.subnet_gcp.private_subnets["scd"] # subnet where the vm should be 
      public_ip       = false
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80","22"] # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os_version      = "18" # operating system version
      script          = "${file("./script.sh")}" # script to provision the machine
    },
    vm2 = {
      name            = "vm-private-2" # vm name
      subnet          = module.subnet_gcp.private_subnets["scd"] # subnet where the vm should be 
      public_ip       = false
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80","22"] # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os_version      = "18" # operating system version
      script          = "${file("./script.sh")}" # script to provision the machine
    },
    vm3 = {
      name            = "vm-public-1" # vm name
      subnet          = module.subnet_gcp.public_subnets["first"] # subnet where the vm should be 
      public_ip       = true
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80","22"] # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os_version      = "18" # operating system version
      script          = "${file("./script.sh")}" # script to provision the machine
    },
  }
}

module "load_balancer" {
  source                  = "./modules/load_balancer"
  gcp_credentials         = file("./creds.json")
  gcp_project_id          = jsondecode(file("./creds.json")).project_id
  gcp_region              = "us-central1"
  zone                    = "us-central1-a"
  #vpc_name                = module.vpc_gcp.vpc["vpc1"].name
  name                    = "prod-application-lb"
  description             = "a simple application load balancer"
  type                    = "application" # or network
  exposure                = "external" # or internal
  bind_port               = "80"
  bind_port_name          = "http" # name as label to index the port
  target_vms              = module.vm.avl_vm # balance traffic to this servers
  health_check            = {
    timeout_sec         = 1
    check_interval_sec  = 1
    healthy_threshold   = 3
    unhealthy_threshold = 2
    port                = 80
    request_path        = "/"
    proxy_header        = "NONE"
  }
}

module "alert" {
  source        = "./modules/alert/gcp"
  gcp_credentials         = file("./creds.json")
  gcp_project_id          = jsondecode(file("./creds.json")).project_id
  gcp_region              = "us-central1"
  load_balancer = module.load_balancer.infos # if not set or null value the alert will be ignored
  name          = "alertRequestCount" # other type will be available in futur versions
  combiner      = "OR" # AND
  condition     = {
    name               = "condition-name"
    duration           = 60
    comparaison        = ">" # "<"
    threshold_value    = 10
    alignment_period   = "300" # en seconde 
    per_series_aligner = "ALIGN_SUM" # other aligners will be available in futur versions
  }
  notification  = {
    name  = "email-notifier"
    type  = "email" # other types will be available in futur versions
    email = "islem.meghnine06@gmail.com" # email to rcv notification
  }
}






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



