resource "google_compute_instance" "terr_vms" {
  count     = var.servers_count
  
  name         = "terr-vm${count.index +1}"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = var.terr_private_subnet_name
  }
  
  metadata_startup_script = file("./script.sh")
  tags                    = ["terr-allow-http"]
}
