# Configure the GCP Provider
provider "google" { 
    credentials = var.gcp_credentials
    project     = var.gcp_project_id  
    region      = var.gcp_region
}

resource "google_compute_instance" "vms" {
    for_each     = var.vms  
    name         = each.value.name  
    machine_type = each.value.machine_type

    tags = length(each.value.open_ports) > 0 ? ["${each.value.name}_fw_auth"] : []

    boot_disk {    
        initialize_params {      
            image = "ubuntu-os-cloud/ubuntu-2004-lts"  
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
    metadata_startup_script = try(each.value.script, "")
}
