module "network" {
  source            = "./modules/networking"
  terr_vms_group_id = module.compute.terr_vms_group_id
  project_id = var.project_id
}

module "compute" {
  source                   = "./modules/compute"
  terr_private_subnet_name = module.network.terr_private_subnet_name
  terr_vpc_name            = module.network.terr_vpc_name
}

module "monitoring" {
  source = "./modules/monitoring"
  lb_name = module.network.lb_name
}
