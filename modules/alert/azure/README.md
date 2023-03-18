# Terrafrom alert module
This module allows creating a RequestCount Alarm in the cloud provider AZURE. 

# Usage (code snippet)
In the root directory : 

    module "alert" {
        source                = "./modules/alert/azure" 
        azure_subscription_id = YOUR_SUBSCRIPTION_ID
        azure_resource_group  = YOUR_RESSOURCE_GROUPE
        name                  = NAME
        window_size           = "PT1M" 
        threshold             = 10
        load_balancer_id      = LOAD_BALANCER_ID
    }


# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure_subscription_id | credential for azure if specified in the providers list | `string` | `""` | yes |
| resource_group_name | resource group where the virtual network is to be created if azure is specified in the providers list | `string` |  | yes |
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| window_size | The period of time that is used to monitor alert activity, represented in ISO 8601 duration format.Possible values are "PT1M", "PT5M", "PT15M", "PT30M", ""PT1H", "PT6H", "PT12H" and "P1D" | `string` | "PTM1"| no |
| threshold | The number of requests needed to make an alert  | `number` |10 | no |
| load_balancer_id | The id of the load balancer  | `string` | | yes |






# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| alert | `object` | Resource object created |
