# Terrafrom Virtual Machine module
This module allows creating Virtual Machines in the cloud provider AWS. The resources resulting are :
- Virtual machines with specified configuration
- A security group associated with the VMs to set the connectivity

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/vm/aws"
        
        # AWS credentials
        aws_access_key = YOUR_KEY
        aws_secrect_key = YOUR_KEY
       
        # resource properties
        aws_region = us-central-1
        cpu_architechture    = "x86_64"
        open_ports= ["80", "22", "443"]
        ssh_key   = file("./id_rsa.pub")
        configuration = "manual"
       
        # map of vms to create
        vms = {
            vm1 = {
                name      = "Vm1"
                subnet    = SUBNET_ID
                public_ip = true
                user_data   = filebase64("./script.sh")

                ram           = "8"
                cpu_cores     = "2"
                os            = "Ubuntu"
                os_version    = "18"
            }
        }
    }

# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_access_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_secret_key | credential for aws if specified in the providers list | `string` |  | yes |
| aws_region | region for AWS | `string` |  | yes |
| subnet_id | subnet ID where the vms is to be created  | `string` | | yes |
| configuration | wheter you need a default hardware parameter or set it manually. Allowed values : "auto", "manual"  | `string` | "auto" | no |
| architechture | System architechture which impacts the operating system image & the machine's hardware. Allowed values : "x86_64", "arm"  | `string` | "x86_64" | no |
| open_ports | the list of ports to expose externally  | `list(number)` | | no |
| vms | map of the resources to be created | `map(map)` |  | yes |

## Arguments for "vms"
"vms" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers erros)  | `string` | | yes |
| public_ip | whether the instance should have a public IP. Allowed value : true, false  | `boolean` | | yes |
| ram | size of the machine's RAM in GB  | `string` | | yes |
| cpu_cores | number of machine's CPU cores  | `string` | | yes |
| os | Operating system of the machine  | `string` | | yes |
| os_version | Version of the operating system  | `string` | | yes |
| owners | list of OS mage owners  | `list` | | yes |
| user_data | script ran at machine initial startup  | `string` | | no |

# Outputs
| Name | Type | Description |
|------|-------------|:--------:|
| vms | `map(map)` | map of created resources with all attributes accessible including private & public IPs |
| sg_id | `string` | ID of the security group created for the VMs connectivity |

