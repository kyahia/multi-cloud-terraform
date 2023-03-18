# Terrafrom LOAD BALANCER module
This module allows creating a Load balancer in the cloud provider AZURE. The resources resulting are :
- a Load Balancer (if type is "network", internal or external facing scheme)
- an Application Gateway (if type is "application", internal or external facing scheme)
- a target group with healthcheck
- a front-end listner

# Usage (code snippet)
In the root directory : 

        module "load_balancer2" {
            # path to module
            source                = "./modules/load_balancer/azure"
            resource_group_name   = YOUR_RESOURCE_GROUP
            azure_subscription_id = YOUR_ID
            virtual_network_id    = VNET_ID
            location              = "South Central US"      
            type                  = "application"
            scheme                = "External"
            subnet                = subnet_id
            name                  = CUSTOM_NAME
            capacity              = number
            ports                 = [80,]    
            vms                   = [ip1, ip2] 
        }


# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure_subscription_id | credential for azure if specified in the providers list | `string` | `""` | yes |
| resource_group_name | resource group where the virtual network is to be created if azure is specified in the providers list | `string` |  | yes |
| location | region for AZURE | `string` |  | yes |
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| type | The type of the load balancer. Allowed values are "application" or "network" | `string` | "application" | no |
| scheme | The scheme of the load balancer. Allowed values are "External" or "Internal" | `string` | "External" | no |
| subnet | The subnetworks id to associate with the Load Balancer | `string` |  | yes |
| capacity | The Maximum number of ressources in the backend pool | `number` | 10 | no |
| ports | The open ports of the load balancer | `list` |  | yes |
| vms | The ips of the ressources in the backend pool  | `list` |  | yes |




# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| load_balancer | `object` | Resource object created |
