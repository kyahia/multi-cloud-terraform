output "nat_id" {
  value = try(azurerm_nat_gateway.nat[0].id, var.nat_id)
}

output "nat" {
  value = try(azurerm_nat_gateway.nat[0], {})
}

