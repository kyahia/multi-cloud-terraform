resource "google_compute_firewall" "private_subnet_rule" {
    name     = "firewall-for-private-subnets"
    network  = var.vpc_name

    deny {
      protocol = "tcp"
      ports    = [ "0-65535" ]
    }

    deny {
      protocol = "udp"
      ports    = [ "0-65535"]
    }

    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]
}