# Terrafrom Network Address Translator module
This module allows creating/editing a NAT in the cloud provider AWS. The resulting resources are:
- A NAT if no nat_id is entred in inputs
- An elastic IP to associate with the created NAT
- A route table to associate the private subnets with the NAT

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/nat/aws"
        
        # AWS credentials
        aws_access_key = YOUR_KEY
        aws_secrect_key = YOUR_KEY
       
        # resource properties
        aws_region = us-central-1
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
| aws_access_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_secret_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_region | region for AWS | `string` |  | yes |
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| nat_id | the id of a NAT already existing that you want to edit the subnets association list | `string` | | no |
| public_subnet_id | public subnet where the NAT is located| `string` |  | yes |
| private_subnet_ids | map of the private subnetworks ids to associate with the NAT | `map(string)` |  | yes |

# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| nat | `string` | the NAT resource created/edited |
