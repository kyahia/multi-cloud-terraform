output public_subnets {
    value = google_compute_subnetwork.public_subnets
}

output private_subnets {
    value = google_compute_subnetwork.private_subnets
}