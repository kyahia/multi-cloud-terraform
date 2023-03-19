output "machine_filter" {
  value = local.selected
}

output "vms" {
  value = google_compute_instance.vms
}

output "os" {
  value = local.filtered
}