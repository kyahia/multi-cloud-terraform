output "vpc_id" {
  value = azurerm_virtual_network.VPC.id
}

output "pub_subnet_id" {
  value = azurerm_subnet.subnets["public_subnet"].id
}

output "prv_subnet_id" {
  value = azurerm_subnet.subnets["private_subnet"].id
}
