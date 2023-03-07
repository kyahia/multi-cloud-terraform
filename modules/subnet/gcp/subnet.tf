resource "google_compute_subnetwork" "terr_private_subnet" {
  for_each = var.subnets
  name          = each.value.name
  network       = each.value.network_name
  ip_cidr_range = each.value.ip_cidr_range
}