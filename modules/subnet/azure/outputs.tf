output "private_subnets" {
  value = local.private_subnets
}
output "public_subnets" {
  value = local.public_subnets
}

output "subnets" {
  value = azurerm_subnet.subnets
}



