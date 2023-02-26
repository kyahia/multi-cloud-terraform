# create a default route using the default internet gateway created automatically by google cloud
resource "google_compute_route" "terr_public_routing" {
  name             = "terr-public-routing"
  network          = google_compute_network.terr_vpc.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}
