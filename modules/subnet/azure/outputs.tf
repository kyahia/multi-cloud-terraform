output "private_subnet" {
  value = azurerm_subnet.private_subnets
}
output "public_subnet" {
  value = azurerm_subnet.public_subnets
}

