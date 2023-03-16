output "private_subnets" {
  value = azurerm_subnet.private_subnets
}
output "public_subnets" {
  value = azurerm_subnet.public_subnets
}

output "subnets" {
  value = merge(azurerm_subnet.public_subnets, azurerm_subnet.private_subnets)
}



