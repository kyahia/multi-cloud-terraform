# Terrafrom Load Balancer module
This module allows creating a Load balancer in the cloud provider AWS. The resources resulting are :
- a Load Balancer (network or application type, internal or external facing scheme)
- a target group with healthcheck
- a front-end listner
- a security group for the Load Balancer connectivity if an existing ID isn't entered as input

# Usage (code snippet)
In the root directory : 

    module "load_balancer" {
        source            = "./modules/load_balancers/aws"
        aws_region        = var.aws_region
        aws_access_key    = var.aws_access_key
        aws_secret_key    = var.aws_secret_key
        vpc_id            = module.vpc_aws.vpc_id
        subnets = [module.subnet_aws.private_subnet_id, module.subnet_aws.public_subnet_id]
        type = "application"
        scheme = "external"
        vm_ids = {
            vm1_id = "",
            vm2_id = ""
        }
    }


# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_access_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_secret_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_region | region for AWS | `string` |  | yes |
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| vpc_id | the ID of the VPC of the Load Balancer | `string` | | yes |
| subnets | list of the subnetworks ids to associate with the Load Balancer. In the case of an application LB the list must include subnets in 2 different availability zones at least  | `list(string)` |  | yes |
| sg_id | ID of a security group to associate with the Load Balancer (one will be created if not specified) | `string` |  | no |
| scheme | Balacing scheme. Allowed values are "internal" or "external" | `string` | "external" | no |
| type | Type (layer) of the Load Balancer. Allowed values are "application" or "network" | `string` | "application" | no |
| port | Port of the vms for balancing.  | `number` | "application" | no |
| vm_ids | map of the subnetworks ids to associate with the Load Balancer | `map(string)` |  | yes |



# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| lb | `object` | Resource object created |
