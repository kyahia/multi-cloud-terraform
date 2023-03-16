/* locals {
    vm_keys = [ for key,vm in var.vms : length(vm.open_ports) > 0 ? key : null]
    vms     = {
        for vm_key in var.vm_keys : vm_key => vm_key != null ? vm_key : {
            name         = var.vms[vm_key].name
            subnet       = var.vms[vm_key].subnet
            public_ip    = var.vms[vm_key].public_ip
            description  = var.vms[vm_key].description
            open_ports   = var.vms[vm_key].open_ports
            ssh_key      = var.vms[vm_key].ssh_key
            ram          = var.vms[vm_key].ram
            cores        = var.vms[vm_key].cores
            os_version   = var.vms[vm_key].os_version
            machine_type = var.vms[vm_key].machine_type
            script       = var.vms[vm_key].script
        }
    }
} */

resource "google_compute_firewall" "rule_vm_auth_ports" {
    for_each = {for vm_key,vm in var.vms: vm_key => vm if length(vm.open_ports) > 0}
    name     = "firewall-vm-auth-ports-for-${each.value.name}"
    network  = var.vpc_name
    description = each.value.description
    
    disabled = each.value.disable_fw_rule

    allow {
        protocol = "tcp"
        ports    = each.value.open_ports
    }

    # if public ip flag is on the firewall expose machine services to internet else open ports internaly with all subnets 
    source_ranges = ["0.0.0.0/0"] #each.value.public_ip ? [ "0.0.0.0/0" ] : [ auth ip ]
    target_tags = ["${each.value.name}-fw-auth"]
}