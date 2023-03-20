# Terrafrom Subnetwork module
This module allows creating SUBNETWORKS in the cloud providers AWS. The resources resulting are :
- Internet Gateway to allow internet access to public subnetworks if specified(or use existing if provided as input)
- Route table associating public subnetworks with the internet gateway
- Public Subnets (if specified)
- Private Subnets (if specified)

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/subnet/aws"
        
        # AWS credentials
        aws_access_key = YOUR_KEY
        aws_secrect_key = YOUR_KEY
       
        # resource properties
        aws_region = "us-central-1"
        vpc_id = VPC_ID
        cidr_mode = "auto"

        # map of subnets to create
        subnets = {
            sub1 = {
                name = "test-sub-1"
                type = "private"
                availability_zone = "us-central-1a"
            },
            sub2 = {
                name = "test-sub-2"
                type = "public"
                availability_zone = "us-central-1a"
            }
        }
    }

# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_access_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_secret_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_region | region for AWS | `string` |  | yes |
| vpc_id | ID of the parent VPC | `string` |  | yes |
| internet_gateway_id | ID of an Internet Gateway already existing in the parent VPC. If not specified, one will be created in case there is a public subnet in subnets map | `string` | | no |
| previous_subnets | list of previous subnets | `list` | [] | yes(if cidr_block is not specified)  |
| subnets | map of the resources to be created | `map(map)` |  | yes |

## Arguments for "subnetworks"
"subnets" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| type | Whether the resources inside the subnet have direct access to internet. Allowed value are : "public" or "private"  | `string` | "public" | no |
| cidr_block  | the IP range for the subnet  | `string` | "10.0.[0-255].0/24" | no |
| availability_zone  | The availability zone of the subnet  | `string` | | yes |

# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| public_subnets | map(map) | map of created resources of type "public" with all attributes accessible |
| private_subnets | map(map) | map of created resources of type "private" with all attributes accessible |
| subnets | map(map) | map of created resources of both types with all attributes accessible |
