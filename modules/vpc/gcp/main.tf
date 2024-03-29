# Configure the GCP Provider
provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project_id
  region      = var.gcp_region
}

resource "google_compute_network" "vpc" {
  for_each                = var.vpcs
  name                    = each.value.name
  auto_create_subnetworks = false
}


