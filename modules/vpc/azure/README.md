# Terrafrom Private Network module
This module allows creating VPC "Virtual Private Cloud networks" in the cloud providers AZURE

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/vpc/azure"
        
        # AZURE credentials
        azure_subscription_id = YOUR_ID
        resource_group_name = YOUR_RESOURCE_GROUP

        # resource properties
        azure_location = "South Central US"

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
| azure_subscription_id | credential for azure | `string` | `""` | yes |
| resource_group_name | resource group where the virtual network is to be created | `string` |  | yes |
| azure_location | region for AZURE | `string` |  | yes |
| vpcs | map of the resources to be created | `map(map)` |  | yes |


## Arguments for "vpcs"
"vpcs" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers erros)  | `string` | | yes |
| location | The location of the resource  | `string` | | yes |
| cidr_block | The IP range of the resource | `string` | "10.0.0.0/16" | no |



# Outputs
| Name | Type | Description |
|------|-------------|:--------:|
| vpcs | map(map) | map of created resources with all attributes accessible |