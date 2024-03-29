# Configure the GCP Provider
provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project_id
  region      = var.gcp_region
}

resource "google_compute_router_nat" "nat_gateway" {
#   count  = var.nat_id != "" ? 1 : 0
  name   = "nat-gateway"
  router = google_compute_router.nat_router[0].name
  
  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = var.subnets
    content {
      name                    = subnetwork.value
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}

resource "google_compute_router" "nat_router" {
  count   = length(var.subnets) > 0 ? 1 : 0
  name    = "nat-router"
  network = var.vpc_name
}

