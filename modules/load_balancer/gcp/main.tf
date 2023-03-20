provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project_id
  region      = var.gcp_region
}


################### Application load balancer #####################

resource "google_compute_instance_group" "instance_group" {
  for_each  = upper(var.type) == "APPLICATION" ? { c = 1 } : {}
  name      = "${var.name}-groupe-instance"
  zone      = var.zone
  instances = var.target_vms
  named_port {
    name = var.port_name
    port = var.port
  }
}

resource "google_compute_health_check" "health_check" {
  for_each            = upper(var.type) == "APPLICATION" && var.health_check != null ? { c = 1 } : {}
  name                = "${var.name}-healthcheck"
  timeout_sec         = var.health_check.timeout_sec
  check_interval_sec  = var.health_check.check_interval_sec
  healthy_threshold   = var.health_check.healthy_threshold
  unhealthy_threshold = var.health_check.unhealthy_threshold
  http_health_check {
    port         = tonumber(var.health_check.port)
    request_path = try(var.health_check.request_path, "/")
    proxy_header = var.health_check.proxy_header == "" ? "NONE" : var.health_check.proxy_header
  }
}

# defines a group of virtual machines that will serve traffic for load balancing
resource "google_compute_backend_service" "backend_service" {
  for_each      = upper(var.type) == "APPLICATION" ? { c = 1 } : {}
  name          = "${var.name}-backend-service"
  port_name     = var.port_name
  protocol      = tonumber(var.port) == 80 ? "HTTP" : "HTTPS"
  health_checks = ["${google_compute_health_check.health_check["c"].self_link}"]
  depends_on = [
    google_compute_health_check.health_check,
    google_compute_instance_group.instance_group,
  ]

  backend {
    group                 = google_compute_instance_group.instance_group["c"].self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "url_map" {
  for_each = upper(var.type) == "APPLICATION" ? { c = 1 } : {}
  name     = "${var.name}-url-map"
  depends_on = [
    google_compute_backend_service.backend_service
  ]
  default_service = google_compute_backend_service.backend_service["c"].self_link
}

# used by one or more global forwarding rule to route incoming HTTP requests to a URL map
resource "google_compute_target_http_proxy" "target_http_proxy" {
  for_each = upper(var.type) == "APPLICATION" ? { c = 1 } : {}
  name     = "${var.name}-proxy"
  depends_on = [
    google_compute_url_map.url_map
  ]
  url_map = google_compute_url_map.url_map["c"].self_link
}

# Load balancer with unmanaged instance group  used to forward traffic to the correct load balancer for HTTP load balancing
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  for_each              = upper(var.type) == "APPLICATION" ? { c = 1 } : {}
  name                  = "${var.name}-global-forwarding-rule"
  load_balancing_scheme = upper(var.scheme)
  depends_on = [
    google_compute_target_http_proxy.target_http_proxy
  ]
  target     = google_compute_target_http_proxy.target_http_proxy["c"].self_link
  port_range = var.port
}

################### Network load balancer #####################

resource "google_compute_forwarding_rule" "forward_rule_nlb" {
  for_each              = upper(var.type) == "NETWORK" ? { c = 1 } : {}
  name                  = "${var.name}-forwarad-rule-nlb"
  target                = google_compute_target_pool.target_pool_nlb["c"].self_link
  load_balancing_scheme = upper(var.scheme)
  port_range            = var.port
  region                = var.gcp_region
  ip_protocol           = "TCP"
  depends_on = [
    google_compute_target_pool.target_pool_nlb
  ]
}

# lb pool to define target server for balancing the payloads
resource "google_compute_target_pool" "target_pool_nlb" {
  for_each         = upper(var.type) == "NETWORK" ? { c = 1 } : {}
  name             = "${var.name}-target-pool-nlb"
  session_affinity = "NONE"
  instances        = var.target_vms
  health_checks    = [google_compute_http_health_check.health_check_nlb["c"].self_link]
  depends_on = [
    google_compute_http_health_check.health_check_nlb,
  ]
}

# health check

resource "google_compute_http_health_check" "health_check_nlb" {
  for_each = upper(var.type) == "NETWORK" && var.health_check != null ? { c = 1 } : {}
  name     = "${var.name}-healthcheck-nlb"

  check_interval_sec  = var.health_check.check_interval_sec
  healthy_threshold   = var.health_check.healthy_threshold
  timeout_sec         = var.health_check.timeout_sec
  unhealthy_threshold = var.health_check.unhealthy_threshold

  port         = var.port
  request_path = var.health_check.request_path
} 
