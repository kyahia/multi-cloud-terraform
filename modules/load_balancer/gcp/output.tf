# output "vm" {
#   value = local.vms_id
# }


locals {
  lb = {
    type     = var.type
    name     = var.name
  }
}

output "infos" {
  value = local.lb
}

output lb {
  value = upper(var.type) == "NETWORK" ? google_compute_forwarding_rule.forward_rule_nlb : google_compute_global_forwarding_rule.global_forwarding_rule
}