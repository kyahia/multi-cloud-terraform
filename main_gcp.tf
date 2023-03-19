module "vpc_gcp" {
  source          = "./modules/vpc/gcp"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
  gcp_region      = "us-central1"
  vpcs = {
    vpc1 = {
      name = "vpc"
    }
  }
}


module "subnet_gcp" {
  source          = "./modules/subnet/gcp"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
  gcp_region      = "us-central1"
  cidr_mode       = "auto"
  vpc_name        = module.vpc_gcp.vpc["vpc1"].name

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
  source          = "./modules/nat/gcp"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
  gcp_region      = "us-central1"
  subnets         = module.subnet_gcp.private_subnets
  vpc_name        = module.vpc_gcp.vpc["vpc1"].name
}

module "vm" {
  source          = "./modules/vm/gcp"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
  gcp_region      = "us-central1"
  zone            = "us-central1-a"
  vpc_name        = module.vpc_gcp.vpc["vpc1"].name
  vms = {
    vm1 = {
      name            = "vm-private-1"                           # vm name must include private or public , TODO: we need to prevent this
      subnet          = module.subnet_gcp.private_subnets["scd"] # subnet where the vm should be 
      public_ip       = false
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80", "22"]         # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os_version      = "18"                     # operating system version
      script          = "${file("./script.sh")}" # script to provision the machine
    },
    vm2 = {
      name            = "vm-private-2"                           # vm name
      subnet          = module.subnet_gcp.private_subnets["scd"] # subnet where the vm should be 
      public_ip       = false
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80", "22"]         # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os_version      = "18"                     # operating system version
      script          = "${file("./script.sh")}" # script to provision the machine
    },
    vm3 = {
      name            = "vm-public-1"                             # vm name
      subnet          = module.subnet_gcp.public_subnets["first"] # subnet where the vm should be 
      public_ip       = true
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80", "22"]         # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os_version      = "18"                     # operating system version
      script          = "${file("./script.sh")}" # script to provision the machine
    },
  }
}

module "load_balancer" {
  source          = "./modules/load_balancer"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
  gcp_region      = "us-central1"
  zone            = "us-central1-a"
  #vpc_name                = module.vpc_gcp.vpc["vpc1"].name
  name           = "prod-application-lb"
  description    = "a simple application load balancer"
  type           = "application" # or network
  exposure       = "external"    # or internal
  bind_port      = "80"
  bind_port_name = "http"           # name as label to index the port
  target_vms     = module.vm.avl_vm # balance traffic to this servers
  health_check = {
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
  source          = "./modules/alert/gcp"
  gcp_credentials = file("./creds.json")
  gcp_project_id  = jsondecode(file("./creds.json")).project_id
  gcp_region      = "us-central1"
  load_balancer   = module.load_balancer.infos # if not set or null value the alert will be ignored
  name            = "alertRequestCount"        # other type will be available in futur versions
  combiner        = "OR"                       # AND
  condition = {
    name               = "condition-name"
    duration           = 60
    comparaison        = ">" # "<"
    threshold_value    = 10
    alignment_period   = "300"       # en seconde 
    per_series_aligner = "ALIGN_SUM" # other aligners will be available in futur versions
  }
  notification = {
    name  = "email-notifier"
    type  = "email"                      # other types will be available in futur versions
    email = "islem.meghnine06@gmail.com" # email to rcv notification
  }
}






###########################################################################################################
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
  zone                    = "us-central1-a"
  vpc_name                = module.vpc_gcp.vpc["vpc1"].name
  vms = {
    vm1 = {
      name            = "vm-private-1" # vm name must include private or public , TODO: we need to prevent this
      subnet          = module.subnet_gcp.private_subnets["scd"].self_link # subnet where the vm should be 
      public_ip       = false
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80","22"] # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os              = "debian" # operating system version
      os_version      = "11"
      os_arch         = "arm64" 
      script          = "${file("./script.sh")}" # script to provision the machine
    },
    vm2 = {
      name            = "vm-private-2" # vm name
      subnet          = module.subnet_gcp.private_subnets["scd"].self_link # subnet where the vm should be 
      public_ip       = false
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80","22"] # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os              = "ubuntu" # operating system version
      os_version      = "22"
      os_arch         = "arm64" 
      script          = "${file("./script.sh")}" # script to provision the machine
    },
    vm3 = {
      name            = "vm-public-1" # vm name
      subnet          = module.subnet_gcp.public_subnets["first"].self_link # subnet where the vm should be 
      public_ip       = true
      description     = "A simple vm"
      disable_fw_rule = false
      open_ports      = ["80","22"] # allowed open ports 
      ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      username        = "user"
      ram             = 4 # amount of random access memory
      cores           = 2 # cores of cpu
      arch            = "x86"
      os              = "ubuntu" # operating system default debian-cloud/debian-10
      os_version      = "22" # 18 20 22
      os_arch         = "arm64"  
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
  /* alert                   = {
    name        = "alertRequestCount" # other type will be available in futur versions
    combiner    = "OR" # AND
    condition   = {
      name               = "condition-name"
      duration           = 60
      comparaison        = ">" # "<"
      threshold_value    = 10
      alignment_period   = "300" # en seconde 
      per_series_aligner = "ALIGN_SUM" # other aligners will be available in futur versions
    }

    notification = {
      name  = "email notifier"
      type  = "email" # other types will be available in futur versions
      email = "islem.meghnine06@gmail.com" # email to rcv notification
    }
  } */
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


