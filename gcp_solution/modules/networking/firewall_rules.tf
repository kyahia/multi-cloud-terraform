resource "google_compute_firewall" "terr_allow_http" {
  name          = "terr-allow-http"
  network       = google_compute_network.terr_vpc.name
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_tags = ["terr-allow-http"]
}
