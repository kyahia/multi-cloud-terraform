# Configure the GCP Provider
provider "google" { 
    credentials = var.gcp_credentials
    project     = var.gcp_project_id  
    region      = var.gcp_region
}

resource "google_compute_instance" "vms" {  
    for_each = var.vms  
    name         = each.value.name  
    machine_type = "e2-standard-2"  
    zone         = each.value.zone  
    boot_disk {    
        initialize_params {      
            image = "ubuntu-os-cloud/ubuntu-2004-lts"    
        }  
    }  
    network_interface {    
        subnetwork = each.value.subnetwork       
        dynamic "access_config" {      
            for_each = each.value.public ? { a = 1 } : {}      
            content {             

            }    
        }  
    }
    metadata_startup_script = try(each.value.script, "")
    }
