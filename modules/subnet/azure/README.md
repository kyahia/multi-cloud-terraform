# Terrafrom Subnetwork module
This module allows creating SUBNETWORKS in the cloud providers AZURE. The resulting resources are:
- Public Subnets (if specified)
- Private Subnets (if specified)
- Security group for private subnets

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/subnet/azure"
        
        # AZURE credentials
        azure_subscription_id = YOUR_ID
        resource_group_name = YOUR_RESOURCE_GROUP

        # resource properties
        location = "South Central US"
        virtual_network_name = VPC_ID
        cidr_mode = "auto"

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
| azure_subscription_id | credential for azure if specified in the providers list | `string` | `""` | yes(if azure is listed) |
| resource_group_name | resource group where the virtual network is to be created if azure is specified in the providers list | `string` |  | yes(if azure is listed) |
| location | region for AZURE | `string` |  | yes(if AZURE is listed) |
| virtual_network_name | The name of the parent VPC | `string` |  | yes |
| previous_subnets | list of previous subnets | `list` |  | yes(if subnets already exist & cidr_blocks not specified) |
| subnets | map of the resources to be created | `map(map)` |  | yes |

## Arguments for "subnetworks"
"subnetworks" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| type | Whether the resources inside the subnet have direct access to internet. Allowed value are : "public" or "private"  | `string` | "public" | no |
| cidr_block  | the IP range for the subnet  | `string` | "10.0.[0-255].0/24" | no |

# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| public_subnets | map(map) | map of created resources of type "public" with all attributes accessible |
| private_subnets | map(map) | map of created resources of type "private" with all attributes accessible |
| subnets | map(map) | map of created resources with all attributes accessible |
