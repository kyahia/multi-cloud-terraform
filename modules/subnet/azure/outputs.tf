output "private_subnets" {
  value = local.private_subnets
}
output "public_subnets" {
  value = local.public_subnets
}

output "subnets" {
  value = azurerm_subnet.subnets
}

output "security_group_id" {
  value = try(azurerm_network_security_group.prv_nsg[0].id)
}


