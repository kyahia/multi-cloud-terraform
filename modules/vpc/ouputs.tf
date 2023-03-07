variable "vpc_names" {
  value = google_compute_network.vpc.*.name
}