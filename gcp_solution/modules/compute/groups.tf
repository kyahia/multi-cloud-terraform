resource "google_compute_instance_group" "terr_vms_group" {
  name    = "terr-vms-group"
  network = var.terr_vpc_name
  zone = "us-central1-a"
  instances = google_compute_instance.terr_vms.*.self_link

  named_port {
    name = "http"
    port = "80"
  }
}
