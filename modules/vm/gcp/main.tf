# Configure the GCP Provider
provider "google" { 
    credentials = var.gcp_credentials
    project     = var.gcp_project_id  
    region      = var.gcp_region
}

locals {
    # this local variable act like a database storing machine details
    machines = jsondecode(file("./modules/vm/gcp/machines.json"))

    # local variable acting as a function to filter machine details according to user need
    requested_vm_keys = [for vm_key, vm in var.vms: vm_key]
    selected = {
        for key in local.requested_vm_keys: key => {
            for machine_key, machine in local.machines: machine_key => machine.name if machine.cpu == var.vms[key].cores && machine.ram == var.vms[key].ram && machine.arch == upper(var.vms[key].arch)
        }
    }
}

# json file acting like a db to store available OS

locals {
    oss      = jsondecode(file("./images.json"))
    user     = {for key,s in var.vms: key => "${s.os}${s.os_version}-${s.arch}"}
    filtered = {for user_key,user_os in local.user: user_key => {
        for key_os, os in local.oss: "os_name" => os.selfLink if lower(key_os) == lower(user_os)
    }} 
    /* filtred = {for key_os,os in local.oss: key_os => {
        for user_os_key, user_os in var.vms
    }} */
}

resource "google_compute_instance" "vms" {
    for_each     = var.vms 
    name         = each.value.name  
    machine_type = try(values(local.selected[each.key])[0],"e2-standart-2")
    zone = var.zone
    tags = length(each.value.open_ports) > 0 ? ["${each.value.name}-fw-auth"] : []

    boot_disk {    
        initialize_params {      
            image = try(local.filtered[each.key].os_name, "ubuntu-os-cloud/ubuntu-2004-lts")
        }  
    }  
    network_interface {    
        subnetwork = each.value.subnet       
        dynamic "access_config" {      
            for_each = each.value.public_ip ? { c = 1 } : {}      
            content {             

            }    
        }
    }

    metadata_startup_script = try(each.value.custom_data, "")

    metadata = {
        ssh-keys = try("${each.value.username}:${each.value.ssh_key}", null)
    }
}