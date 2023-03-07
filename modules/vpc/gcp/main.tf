# Configure the GCP Provider
provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project_id
  region      = var.gcp_region
}

resource "google_compute_network" "vpc" {
  for_each                = var.vpc
  name                    = each.value.name
}


