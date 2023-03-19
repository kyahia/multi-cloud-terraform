
module "vpc_gcp" {
  source          = "./modules/vpc/gcp"
  gcp_credentials = file(var.gcp_credentials)
  gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
  gcp_region      = "us-central1"
  vpcs = {
    vpc1 = {
      name = "vpc"
    }
  }
}

module "subnet_gcp" {
  source          = "./modules/subnet/gcp"
  gcp_credentials = file(var.gcp_credentials)
  gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
  gcp_region      = "us-central1"
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
  gcp_credentials = file(var.gcp_credentials)
  gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
  gcp_region      = "us-central1"
  subnets         = [module.subnet_gcp.private_subnets["scd"].self_link, module.subnet_gcp.private_subnets["thd"].self_link]
  vpc_name        = module.vpc_gcp.vpc["vpc1"].name
}



module "vm" {
  source          = "./modules/vm/gcp"
  gcp_credentials = file(var.gcp_credentials)
  gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
  gcp_region      = "us-central1"
  zone            = "us-central1-a"
  vpc_name        = module.vpc_gcp.vpc["vpc1"].name
  vms = {
    # vm1 = {
    #   name        = "vm-private-1"                                     # vm name must include private or public , TODO: we need to prevent this
    #   subnet      = module.subnet_gcp.private_subnets["scd"].self_link # subnet where the vm should be 
    #   public_ip   = false
    #   description = "A simple vm"
    #   open_ports  = ["80", "22"] # allowed open ports 
    #   username    = "user"
    #   ram         = 4 # amount of random access memory
    #   cores       = 2 # cores of cpu
    #   arch        = "arm64"
    #   os          = "debian" # operating system version
    #   os_version  = "11"
    #   # ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
    #   # script          = "${file("./script.sh")}" # script to provision the machine
    # },
    vm2 = {
      name        = "vm-private-2"                                     # vm name
      subnet      = module.subnet_gcp.private_subnets["scd"].self_link # subnet where the vm should be 
      public_ip   = false
      description = "A simple vm"
      open_ports  = ["80", "22"] # allowed open ports 
      username    = "user"
      ram         = 4 # amount of random access memory
      cores       = 2 # cores of cpu
      arch        = "x86"
      os          = "ubuntu" # operating system version
      os_version  = "22"
      # ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      script          = "${file("./script2.sh")}" # script to provision the machine
    },
    vm3 = {
      name        = "vm-public-1"                                       # vm name
      subnet      = module.subnet_gcp.public_subnets["first"].self_link # subnet where the vm should be 
      public_ip   = true
      description = "A simple vm"
      open_ports  = ["80", "22"] # allowed open ports 
      username    = "user"
      ram         = 4 # amount of random access memory
      cores       = 2 # cores of cpu
      arch        = "x86"
      os          = "ubuntu" # operating system default debian-cloud/debian-10
      os_version  = "22"     # 18 20 22
      # ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
      # script          = "${file("./script.sh")}" # script to provision the machine
    },
  }
}

module "lb_vms" {
  source          = "./modules/vm/gcp"
  gcp_credentials = file(var.gcp_credentials)
  gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
  gcp_region      = "us-central1"
  zone            = "us-central1-a"
  vpc_name        = module.vpc_gcp.vpc["vpc1"].name
  vms = {
    ser1 = {
      name       = "ser-1"                                            # vm name must include private or public , TODO: we need to prevent this
      subnet     = module.subnet_gcp.private_subnets["scd"].self_link # subnet where the vm should be 
      public_ip  = false
      open_ports = ["80", "22"] # allowed open ports 
      username   = "user"
      ram        = 4 # amount of random access memory
      cores      = 2 # cores of cpu
      arch       = "x86"
      os         = "ubuntu"            # operating system default debian-cloud/debian-10
      os_version = "22"                # 18 20 22
      user_data  = file("./script2.sh") # script to provision the machine
    },
    ser2 = {
      name       = "ser-2"                                            # vm name must include private or public , TODO: we need to prevent this
      subnet     = module.subnet_gcp.private_subnets["scd"].self_link # subnet where the vm should be 
      public_ip  = false
      open_ports = ["80", "22"] # allowed open ports 
      username   = "user"
      ram        = 4 # amount of random access memory
      cores      = 2 # cores of cpu
      arch       = "x86"
      os         = "ubuntu"            # operating system default debian-cloud/debian-10
      os_version = "22"                # 18 20 22
      user_data  = file("./script2.sh") # script to provision the machine
    }
  }
}



module "load_balancer" {
  source          = "./modules/load_balancer/gcp"
  gcp_credentials = file(var.gcp_credentials)
  gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
  gcp_region      = "us-central1"
  zone            = "us-central1-a"
  name            = "prod-application"
  type            = "application" # or network
  scheme          = "external"    # or internal
  port            = "80"
  port_name       = "http"             # name as label to index the port
  target_vms      = [module.lb_vms.vms["ser1"].self_link, module.lb_vms.vms["ser2"].self_link] # balance traffic to this servers
  health_check = {
    timeout_sec         = 1
    check_interval_sec  = 1
    healthy_threshold   = 3
    unhealthy_threshold = 10
    port                = 80
    request_path        = "/"
    proxy_header        = "NONE"
  }
}

module "alert" {
  source          = "./modules/alert/gcp"
  gcp_credentials = file(var.gcp_credentials)
  gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
  gcp_region      = "us-central1"
  # load_balancer   = module.load_balancer.infos # if not set or null value the alert will be ignored
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


