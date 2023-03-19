output public_subnets {
    value = google_compute_subnetwork.public_subnets
}

output private_subnets {
    value = google_compute_subnetwork.private_subnets
}

output subnets {
    value = merge(output.private_subnets, output.public_subnets)
}