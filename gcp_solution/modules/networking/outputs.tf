output "terr_private_subnet_name" {
  value = google_compute_subnetwork.terr_private_subnet.name
}
output "http_lb_ip" {
  value = google_compute_global_forwarding_rule.terr_http_lb.ip_address
}
output "terr_vpc_name" {
  value = google_compute_network.terr_vpc.self_link
}
output "lb_name" {
  value = google_compute_global_forwarding_rule.terr_http_lb.name
}
