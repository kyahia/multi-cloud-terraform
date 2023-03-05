module "networking" {
  source = "./modules/networking"
  vm_ids = module.compute.vm_ids
}

module "compute" {
  source = "./modules/compute"
  private_subnet_id = module.networking.private_subnet_id
  allow_http_sg_id = module.networking.allow_http_sg_id
  servers_count = var.servers_count
}

module "monitoring" {
  source = "./modules/monitoring"
  lb_name = module.networking.lb_name
}
