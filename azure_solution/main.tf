module "network" {
  source = "./modules/network"
  location  = var.location
  resource_group_name = var.resource_group_name
}

module "compute" {
  source = "./modules/compute"
  location  = var.location
  resource_group_name = var.resource_group_name
  private_subnet_id = module.network.prv_subnet_id
  servers_count = var.servers_count
}

module "balancing" {
  source = "./modules/balancing"
  location = var.location
  resource_group_name = var.resource_group_name
  public_subnet_id = module.network.pub_subnet_id
  vms_private_ip = module.compute.vm_private_ips
}

module "monitoring" {
  source = "./modules/monitoring"
  location = var.location
  resource_group_name = var.resource_group_name
  load_balancer_id = module.balancing.alb_id
}

