resource "google_compute_firewall" "rule_vm_auth_ports" {
    for_each = {for vm_key,vm in var.vms: vm_key => vm if length(vm.open_ports) > 0}
    name     = "firewall-vm-auth-ports-for-${each.value.name}"
    network  = var.vpc_name
    description = try(each.value.description, "")
    
    # disabled = each.value.disable_fw_rule

    allow {
        protocol = "tcp"
        ports    = each.value.open_ports
    }

    # if public ip flag is on the firewall expose machine services to internet else open ports internaly with all subnets 
    source_ranges = ["0.0.0.0/0"] #each.value.public_ip ? [ "0.0.0.0/0" ] : [ auth ip ]
    target_tags = ["${each.value.name}-fw-auth"]
}