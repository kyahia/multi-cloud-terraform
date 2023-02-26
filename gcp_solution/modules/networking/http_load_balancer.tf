resource "google_compute_backend_service" "terr_backend_service" {
  name                  = "terr-backend-service"
  project = var.project_id
  #region                = "us-central1"
  port_name = "http"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_http_health_check.terr_http_hc.id]
  backend {
    group = var.terr_vms_group_id
  }
}

resource "google_compute_url_map" "lb_url_map" {
  name            = "lb-url-map"
  description     = "a description"
  default_service = google_compute_backend_service.terr_backend_service.id

  host_rule {
    hosts        = ["infra_ex.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.terr_backend_service.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.terr_backend_service.id
    }
  }
}

resource "google_compute_target_http_proxy" "target_http_proxy" {
  name        = "target-http-proxy"
  url_map     = google_compute_url_map.lb_url_map.id
}

resource "google_compute_address" "lb_ip_address" {
  name         = "lb-ip-address"
  address_type = "EXTERNAL"
}


resource "google_compute_global_forwarding_rule" "terr_http_lb" {
  project = var.project_id
  name        = "terr-http-lb"
  #region = "us-central1"
  target      = google_compute_target_http_proxy.target_http_proxy.id
  #ip_address  = google_compute_address.lb_ip_address.address
  ip_protocol = "TCP"
  port_range  = "80"
}


