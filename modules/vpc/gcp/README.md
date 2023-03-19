# Terrafrom Private Network module
This module allows creating VPC "Virtual Private Cloud networks" in the cloud providers GCP

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/vpc/gcp"
        
        # GCP credentials
        gcp_credentials = file("PATH_TO_CREDENTIALS_JSON")
        gcp_project_id  = YOUR_PROJECT_ID
        
        # resource properties
        gcp_region      = "us-central1"

        # map of vpc to create
        vpcs = {
            my-vpc1 = {
                name = "test-vpc-1"
            },
            my-vpc2 = {
                name = "test-vpc-2"
            }
        }
    }

# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp_credentials | credential for gcp | `string` | `""` | yes |
| gcp_project_id | project ID where the virtual network is to be created | `string` |  | yes |
| gcp_region | region for GCP | `string` |  | yes |
| vpcs | map of the resources to be created | `map(map)` |  | yes |


## Arguments for "vpcs"
"vpcs" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers erros)  | `string` | | yes |



# Outputs
| Name | Type | Description |
|------|-------------|:--------:|
| vpcs | map(map) | map of created resources with all attributes accessible |