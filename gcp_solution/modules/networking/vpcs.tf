resource "google_compute_network" "terr_vpc" {
  name                    = "terr-vpc"
  auto_create_subnetworks = false
}
