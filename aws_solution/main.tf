module "networking" {
  source = "./modules/networking"
  vm1_id = module.compute.vm1_id
  vm2_id = module.compute.vm2_id
}

module "compute" {
  source = "./modules/compute"
  private_subnet_id = module.networking.private_subnet_id
  allow_http_sg_id = module.networking.allow_http_sg_id
}

module "monitoring" {
  source = "./modules/monitoring"
  lb_name = module.networking.lb_name
}
