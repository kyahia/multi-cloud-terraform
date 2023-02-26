#Golable http health check for our instance or target group
resource "google_compute_http_health_check" "terr_http_hc" {
  name               = "terr-http-hc"
  timeout_sec        = 10
  check_interval_sec = 15
  request_path       = "/"
  project = var.project_id
  #healthy_threshold   = 5
  #unhealthy_threshold = 5
}

# Regional health check for our regional backedn service
/*
resource "google_compute_region_health_check" "terr_http_hc" {

  name   = "terr-http-hc"
  region = "us-central1"

  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = "80"
  }

  log_config {
    enable = true
  }
}
*/
