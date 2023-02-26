resource "google_compute_subnetwork" "terr_private_subnet" {
  name          = "terr-private-subnet"
  network       = google_compute_network.terr_vpc.name
  ip_cidr_range = "10.0.10.0/24"
}
