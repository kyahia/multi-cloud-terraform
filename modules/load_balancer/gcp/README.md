# Terrafrom LOAD BALANCER module
This module allows creating a Load balancer in the cloud provider GCP. The resources resulting are :
- a Load Balancer (type "network" or "application", "internal" or "external" facing scheme)
- a target group with healthcheck
- an instance-group/target-pool & back-end service 

# Usage (code snippet)
In the root directory : 

    module "load_balancer2" {
        source          = "./modules/load_balancer/gcp"  
        gcp_credentials = file(var.gcp_credentials)
        gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
        gcp_region      = "us-central1"
        zone            = "us-central1-a"
        name            = "prod-application-lb"
        type            = "application" # or network
        scheme          = "external"    # or internal
        port            = "80"
        target_vms      = VM_ID # balance traffic to this servers
        health_check    = {
            timeout_sec         = 1
            check_interval_sec  = 1
            healthy_threshold   = 3
            unhealthy_threshold = 2
            port                = 80
            request_path        = "/"
            proxy_header        = "NONE"
        } 
    }


# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp_credentials | credential for gcp | `string` | `""` | yes |
| gcp_project_id | project ID where the virtual network is to be created | `string` |  | yes |
| gcp_region | region for GCP | `string` |  | yes |
| zone | zone for the resource | `string` |  | yes |
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| type | The type of the load balancer. Allowed values are "application" or "network" | `string` | "application" | no |
| scheme | The scheme of the load balancer. Allowed values are "External" or "Internal" | `string` | "External" | no |
| port | the port number for balacing | `string` |  | yes |
| port_name | # name as label to index the port | `string` |  | yes |
| target_vms | list of vms self-links | `list` | | yes |
| health_check | chealthcheck parameters  | `map` |  | yes |


# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| load_balancer | `object` | Resource object created |
