output "nat" {
    value = google_compute_router_nat.nat_gateway
}

output "nat_id" {
    value = try(google_compute_router_nat.nat_gateway.id, var.nat_id)
}