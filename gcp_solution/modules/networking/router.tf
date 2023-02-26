# router to add a nat gatewa to it
resource "google_compute_router" "terr_router" {
  name    = "terr-router"
  network = google_compute_network.terr_vpc.name
  region  = "us-central1"
}
# nat gateway to add to the router to provide internet for our instance provisioners
resource "google_compute_router_nat" "terr_ngw" {
  name                               = "terr-ngw"
  region                             = "us-central1"
  router                             = google_compute_router.terr_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
