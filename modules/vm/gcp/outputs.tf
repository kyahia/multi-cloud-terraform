output "machine_filter" {
  value = local.selected
}

output "avl_vm" {
  value = google_compute_instance.vms
}

output "os" {
  value = local.filtered
}