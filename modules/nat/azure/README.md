# Terrafrom Network Address Translator module
This module allows creating/editing a NAT in the cloud provider AZURE. The resulting resources are:
- A NAT if no nat_id is entred in inputs
- A public IP to associate with the created NAT

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/nat/azure"
        
        # AZURE credentials
        azure_subscription_id = YOUR_ID
        resource_group_name = YOUR_RESOURCE_GROUP

        # resource properties
        location = "South Central US"
        name = CUSTOM_NAME

        # map of subnets to create
        subnets = {
            sub1_id = SUBNET1_ID,
            sub2_id = SUBNET2_ID
        }
    }

# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure_subscription_id | credential for azure if specified in the providers list | `string` | `""` | yes |
| resource_group_name | resource group where the virtual network is to be created if azure is specified in the providers list | `string` |  | yes |
| location | region for AZURE | `string` |  | yes |
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| nat_id | the id of a NAT already existing that you want to edit the subnets association list | `string` | | no |
| subnets | map of the subnetworks ids to associate with the NAT | `map(string)` |  | yes |

# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| nat_id | `string` | ID of the NAT created/edited |
| nat | map | map of created resource with all attributes |
