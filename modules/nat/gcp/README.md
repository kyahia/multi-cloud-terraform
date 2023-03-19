# Terrafrom Network Address Translator module
This module allows creating a NAT in the cloud provider GCP. The resulting resources are :
- 

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/nat/gcp"
        
        # GCP credentials
        gcp_credentials = file("PATH_TO_CREDENTIALS_JSON")
        gcp_project_id  = YOUR_PROJECT_ID
        
        # resource properties
        gcp_region      = "us-central1"

        # map of subnets to create
        subnets = {
            sub1_id = SUBNET1_ID,
            sub2_id = SUBNET2_ID
        }
    }

# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp_credentials | credential for gcp | `string` | `""` | yes |
| gcp_project_id | project ID where the virtual network is to be created | `string` |  | yes |
| gcp_region | region for GCP | `string` |  | yes |
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| subnets | map of the subnetworks ids to associate with the NAT | `map(string)` |  | yes |

# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| nat_id | `string` | ID of the NAT created |
| nat | map | map of created resource with all attributes |
