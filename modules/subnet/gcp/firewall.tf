resource "google_compute_firewall" "private_subnet_authorized_inside_rule" {
    name     = "firewall-private-subnet-inside-rule"
    network  = var.vpc_name

    allow {
      protocol = "tcp"
      ports    = [ "0-65535" ]
    }

    allow {
      protocol = "udp"
      ports    = [ "0-65535"]
    }

    priority = 1002

    destination_ranges = [for subnet in local.private_subnets: subnet.cidr_block]
    source_ranges = [for subnet in local.private_subnets: subnet.cidr_block]
}

resource "google_compute_firewall" "private_subnet_forbidden_outside_rule" {
    name     = "firewall-private-subnet-ouside-rule"
    network  = var.vpc_name

    deny {
      protocol = "tcp"
      ports    = [ "0-65535" ]
    }

    deny {
      protocol = "udp"
      ports    = [ "0-65535"]
    }

    priority = 1003

    destination_ranges = [for subnet in local.private_subnets: subnet.cidr_block]
    source_ranges = ["0.0.0.0/0"]
}

