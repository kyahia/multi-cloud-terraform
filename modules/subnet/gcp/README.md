# Terrafrom Subnetwork module
This module allows creating SUBNETWORKS in the cloud providers GCP

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/subnet/azure"
        
        # GCP credentials
        gcp_credentials = file("PATH_TO_CREDENTIALS_JSON")
        gcp_project_id  = YOUR_PROJECT_ID
        
        # resource properties
        gcp_region      = "us-central1"

        # map of subnets to create
        subnets = {
            sub1 = {
                name = "test-vpc-1"
                type = "private"
            },
            sub2 = {
                name = "test-vpc-2"
                type = "public"
            }
        }
    }

# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp_credentials | credential for gcp | `string` | `""` | yes |
| gcp_project_id | project ID where the virtual network is to be created | `string` |  | yes |
| gcp_region | region for GCP | `string` |  | yes |
| security_group_id | region for GCP | `string` |  | no  |
| subnets | map of the resources to be created | `map(map)` |  | yes |

## Arguments for "subnetworks"
"subnetworks" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| type | Whether the resources inside the subnet have direct access to internet. Allowed value are : "public" or "private"  | `string` | "public" | no |
| cidr_block  | The name of the resource (prefferably unique to avoid cloud providers erros)  | `string` | | yes(if cidr_mode is set to manual) |

# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| subnets | map(map) | map of created resources with all attributes accessible |
