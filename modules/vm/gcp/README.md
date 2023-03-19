# Terrafrom Virtual Machine module
This module allows creating a Virtual Machine in the cloud provider GCP

# Usage (code snippet)
In the root directory : 

    module "CUSTOM_NAME" : {
        # path to module
        source = "./modules/vm/gcp"
        gcp_credentials         = file("./creds.json")
        gcp_project_id          = jsondecode(file("./creds.json")).project_id
        gcp_region              = "us-central1"
        zone                    = "us-central1-a"
        vpc_name                = module.vpc_gcp.vpc["vpc1"].name
        vms = {
            vm1 = {
                name            = "vm-private-1" # vm name must include private or public , TODO: we need to prevent this
                subnet          = module.subnet_gcp.private_subnets["scd"].self_link # subnet where the vm should be 
                public_ip       = false
                open_ports      = ["80","22"] # allowed open ports 
                ssh_key         = file("./id_rsa.pub") # upload ssh key to configure ssh
                username        = "user"
                ram             = 4 # amount of random access memory
                cores           = 2 # cores of cpu
                arch            = "x86"
                os              = "debian" # operating system version
                os_version      = "11"
                arch            = "arm" 
                custom_data          = "${file("./script.sh")}" # script to provision the machine
            }
        }
    }

# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp_credentials | credential for gcp | `string` | `""` | yes |
| gcp_project_id | project ID where the virtual network is to be created | `string` |  | yes |
| gcp_region | region for GCP | `string` |  | yes |
| vms | map of the resources to be created | `map(map)` |  | yes |

## Arguments for "vms"
"vms" represents a map of the desired resources. Each element has the key/value pairs below :

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource (prefferably unique to avoid cloud providers erros)  | `string` | | yes |
| subnet | subnet self-link where the resource is to be created  | `string` | | yes |
| public_ip | whether the instance should have a public IP. Allowed value : "enable", "disable"  | `string` | | yes |
| open_ports | the list of ports to expose externally  | `list(string)` | | yes |
| username | the virtual machine's username  | `string` | | yes |
| ssh_key | the ssh public key  | `string` | | no |
| ram | size of the machine's RAM in GB  | `string` | | yes |
| cores | number of machine's CPU cores  | `string` | | yes |
| os | Operating system of the machine  | `string` | | yes |
| version | Version of the operating system  | `string` | | yes |
| arch | System architechture which impacts the operating system image & the machine's hardware. Allowed values : "X86", "arm64"  | `string` | | yes |
| custom_data | script ran at machine initial startup  | `string` | | yes |

# Outputs
| Name | Type | Description |
|------|-------------|:--------:|
| vms | map(map) | map of created resources with all attributes accessible |