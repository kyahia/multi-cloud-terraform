# Terrafrom Private Network module
This module allows creating VPC "Virtual Private Cloud networks" in the cloud providers AWS

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/vpc/aws"
        
        # AWS credentials
        aws_access_key = YOUR_KEY
        aws_secrect_key = YOUR_KEY
       
        # resource properties
        aws_region = us-central-1
       
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
| aws_access_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_secret_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_region | region for AWS | `string` |  | yes |
| vpcs | map of the resources to be created | `map(map)` |  | yes |

## Arguments for "vpcs"
"vpcs" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers erros)  | `string` | | yes |
| cidr_block | The IP range of the VPC | `string` | "10.0.0.0/16" | no |


# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| vpcs | map(map) | map of created resources with all attributes accessible |