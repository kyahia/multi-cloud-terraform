resource "google_compute_firewall" "private_subnet_rule" {
    for_each = local.private_subnets
    name     = "firewall-${each.value.name}"
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