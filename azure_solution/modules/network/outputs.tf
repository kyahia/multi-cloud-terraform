output "vpc_id" {
  value = azurerm_virtual_network.VPC.id
}

output "pub_subnet_id" {
  value = azurerm_subnet.public_subnet.id
}

output "prv_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}

# output "nat_id" {
#   value = azurerm_nat_gateway.nat.id
# }
