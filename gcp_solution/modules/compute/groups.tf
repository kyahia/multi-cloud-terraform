resource "google_compute_instance_group" "terr_vms_group" {
  name    = "terr-vms-group"
  network = var.terr_vpc_name
  zone = "us-central1-a"
  named_port {
    name = "http"
    port = "80"
  }
  instances = [
    google_compute_instance.terr_vms["vm1"].self_link,
    google_compute_instance.terr_vms["vm2"].self_link
  ]

}
