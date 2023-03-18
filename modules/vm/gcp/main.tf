# Configure the GCP Provider
provider "google" { 
    credentials = var.gcp_credentials
    project     = var.gcp_project_id  
    region      = var.gcp_region
}

# this local variable act like a database storing machine details
locals {
    machines = {
        machine1 = {
            name = "n1-standard-1"
            cpu  = 1
            ram  = 2
            arch = "X86"
        },
        machine2 = {
            name = "e2-medium"
            cpu  = 2
            ram  = 4
            arch = "X86"
        },
        machine3 = {
            name = "e2-standard-2"
            cpu  = 2
            ram  = 8
            arch = "X86"
        },
        machine4 = {
            name = "c2d-highcpu-4"
            cpu  = 4
            ram  = 8
            arch = "X86"
        },
        machine5 = {
            name = "e2-standard-4"
            cpu  = 4
            ram  = 16
            arch = "X86"
        },
        machine6 = {
            name = "c2d-highcpu-8"
            cpu  = 8
            ram  = 16
            arch = "X86"
        },
        machine7 = {
            name = "e2-standard-8"
            cpu  = 8
            ram  = 32
            arch = "X86"
        },
        machine8 = {
            name = "t2a-standard-1"
            cpu  = 2
            ram  = 4
            arch = "ARM"
        },
        machine9 = {
            name = "n1-standard-1"
            cpu  = 1
            ram  = 2
            arch = "ARM"
        },
        machine10 = {
            name = "t2a-standard-2"
            cpu  = 2
            ram  = 8
            arch = "ARM"
        },
        machine11 = {
            name = "t2a-standard-4"
            cpu  = 4
            ram  = 4
            arch = "ARM"
        },
        machine12 = {
            name = "t2a-standard-4"
            cpu  = 4
            ram  = 16
            arch = "ARM"
        },
        machine13 = {
            name = "t2a-standard-8"
            cpu  = 8
            ram  = 16
            arch = "ARM"
        },
    }
}

# local variable acting as a function to filter machine details according to user need
locals {
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
        subnetwork = each.value.subnet.self_link       
        dynamic "access_config" {      
            for_each = each.value.public_ip ? { c = 1 } : {}      
            content {             

            }    
        }
    }

    metadata_startup_script = each.value.script

    metadata = {
        ssh-keys = "${each.value.username}:${each.value.ssh_key}"
    }
}
