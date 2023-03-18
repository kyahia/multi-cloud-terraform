output "vm" {
  value = local.vms_id
}


locals {
  lb = {
    type     = var.type
    name     = var.name
  }
}

output "infos" {
  value = local.lb
}