# Terrafrom alert module
This module allows creating a RequestCount Alarm in the cloud provider GCP. 

# Usage (code snippet)
In the root directory : 

    module "alert" {
        source          = "./modules/alert/gcp
        gcp_credentials = file(var.gcp_credentials)
        gcp_project_id  = jsondecode(file(var.gcp_credentials)).project_id
        gcp_region      = "us-central1"
        name            = "alertRequestCount"        # other type will be available in futur versions
        combiner        = "OR"                       # AND
        condition = {
            name               = "condition-name"
            duration           = 60
            comparaison        = ">" # "<"
            threshold_value    = 10
            alignment_period   = "300"       # en seconde 
            per_series_aligner = "ALIGN_SUM" # other aligners will be available in futur versions
        }
        notification = {
            name  = "email-notifier"
            type  = "email"                      # other types will be available in futur versions
            email = "islem.meghnine06@gmail.com" # email to rcv notification
        }
    }


# Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp_credentials | credential for gcp | `string` | `""` | yes |
| gcp_project_id | project ID where the virtual network is to be created | `string` |  | yes |
| gcp_region | region for GCP | `string` |  | yes |
| name | The name of the resource (prefferably unique to avoid cloud providers errors)  | `string` | | yes |
| comnbiner | the logical parameter for the metric | `string` | | yes |
| threshold | The number of requests needed to make an alert  | `number` |10 | no |
| condition | The conditions to trigger the alarm  | `map` | | yes |
| notification | The notification parameter  | `map` | | yes |


# Ouputs
| Name | Type | Description |
|------|-------------|:--------:|
| alert | `object` | Resource object created |
