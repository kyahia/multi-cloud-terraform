# Terrafrom alert module
This module allows creating a RequestCount Alarm in the cloud provider AWS. 

# Usage (code snippet)
In the root directory : 

    module "alert" {
        source            = "./modules/alert/aws" 
        aws_region        = var.aws_region
        aws_access_key    = var.aws_access_key
        aws_secret_key    = var.aws_secret_key
        lb_name           = module.load_balancer.lb.name
    }


# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_access_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_secret_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_region | region for AWS | `string` |  | yes |
| lb_name | The name of the load balancer  | `string` | | yes |

# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| alert | `object` | Resource object created |
