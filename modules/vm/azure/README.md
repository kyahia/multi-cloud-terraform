# Terrafrom Virtual Machine module
This module allows creating a Virtual Machine in the cloud provider AZURE

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/vm/azure"
        
        # AZURE credentials
        azure_subscription_id = YOUR_ID
        resource_group_name = YOUR_RESOURCE_GROUP

        # resource properties
        location = "South Central US"

        # map of vms to create
        vms = {
            vm1 = {
                name      = "Vm1"
                subnet    = SUBNET_ID
                public_ip    = "enable"
                openports = ["80", "22", "443"]
                username  = "admin"
                password  = "Admin.2023"
                ssh_key   = file("./id_rsa.pub")

                configuration = "manual"
                ram     = "8"
                cores   = "2"
                os      = "Ubuntu"
                version = "18"
                architechture    = "X86"
                custom_data = filebase64("./script.sh")
            },

            vm2 = {
                name      = "Vm2"
                subnet    = SUBNET_ID
                pubic_ip    = "disable" #enable | disable
                openports = ["80", "22"]
                username  = "admin"
                password  = "admin.2023"

                configuration = "auto"
                custom_data = filebase64("./script.sh")
            }
        }
    }

# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure_subscription_id | credential for azure | `string` | `""` | yes |
| resource_group_name | resource group where the virtual network is to be created | `string` |  | yes |
| location | region for AZURE | `string` |  | yes |
| vms | map of the resources to be created | `map(map)` |  | yes |

## Arguments for "vms"
"vms" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers erros)  | `string` | | yes |
| subnet | subnet ID where the resource is to be created  | `string` | | yes |
| public_ip | whether the instance should have a public IP. Allowed value : "enable", "disable"  | `string` | | yes |
| openports | the list of ports to expose externally  | `list(string)` | | yes |
| username | the virtual machine's username  | `string` | | yes |
| password | the virtual machine's password  | `string` | | yes |
| ssh_key | the ssh public key  | `string` | | yes |
| configuration | wheter you need a default hardware parameter or set it manually. Allowed values : "auto", "manual"  | `string` | | no |
| ram | size of the machine's RAM in GB  | `string` | | yes(if configuration is "manual") |
| cores | number of machine's CPU cores  | `string` | | yes(if configuration is "manual") |
| os | Operating system of the machine  | `string` | | yes(if configuration is "manual") |
| version | Version of the operating system  | `string` | | yes(if configuration is "manual") |
| arch | System architechture which impacts the operating system image & the machine's hardware. Allowed values : "X86", "ARM"  | `string` | | yes(if configuration is "manual") |
| custom_data | script ran at machine initial startup  | `string` | | yes |

# Outputs
| Name | Type | Description |
|------|-------------|:--------:|
| vms | map(map) | map of created resources with all attributes accessible including private & public IPs |