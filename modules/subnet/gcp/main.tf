provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project_id
  region      = var.gcp_region
}

locals {
  subnet_keys     = [ for k, v in var.subnets : k ] #first , sec
  starting_index = length(var.previous_subnets) # 0

  subnets = {
    for key in local.subnet_keys : key => {
      name       = var.subnets[key].name
      type       = var.subnets[key].type
      cidr_block = try(var.subnets[key].cidr_block, cidrsubnet("10.0.0.0/16", 8, index(local.subnet_keys, key) + local.starting_index))
    }
  }

  private_subnets = { for k, v in local.subnets : k => v if v.type == "private" }
  public_subnets  = { for k, v in local.subnets : k => v if v.type == "public" }
}


resource "google_compute_subnetwork" "public_subnets" {
  for_each      = local.public_subnets
  name          = each.value.name
  network       = var.vpc_name
  ip_cidr_range = each.value.cidr_block
}


resource "google_compute_subnetwork" "private_subnets" {
  for_each      = local.private_subnets
  name          = each.value.name
  network       = var.vpc_name
  ip_cidr_range = each.value.cidr_block
}


