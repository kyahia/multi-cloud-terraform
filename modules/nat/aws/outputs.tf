output "nat"{
    value = try(aws_nat_gateway.nat[0], {})
}

output "nat_id"{
    value = try(aws_nat_gateway.nat[0].id, var.nat_id)
}