/*
resource "google_compute_target_pool" "terr_target_pool" {
  name   = "terr-target-pool"
  region = "us-central1"
  instances = [
    var.vm1_url,
    var.vm2_url
  ]
  health_checks = [
    google_compute_http_health_check.terr_http_hc.name
  ]
  session_affinity = "CLIENT_IP"
}

resource "google_compute_forwarding_rule" "terr_lb" {
  name       = "terr-lb"
  target     = google_compute_target_pool.terr_target_pool.id
  port_range = "80"
}
*/
